# Migrating from V1 to V2 of `cloudera-deploy`

## In Summary

1. Don't change your `definition.yml` or `cluster.yml` files.
2. Create a playbook within your project to run your setup. You can start by referencing the following:
   * [Public Cloud](public-cloud/aws/datalake/main.yml)
   * Private Cloud (coming soon!)
3. Create an `ansible-navigator.yml` configuration in your project. You can start by referencing the following:
   * [Public Cloud](public-cloud/aws/datalake/ansible-navigator.yml)
   * Private Cloud (coming soon!)
4. Run your playbook by using `ansible-navigator` vs. `ansible-playbook`.
   * All other arguments apply, so continue to use `-e` and `-t` as needed, e.g. `ansible-navigator run your_playbook.yml -e key=value -t infra,plat,another_tag`

## In Detail

So, you may ask yourself, "How do I run my `cloudera-deploy` V1 playbooks in `ansible-navigator`?" <cue [The Talking Heads](https://youtu.be/5IsSpAOD6K8?si=K4vEs-b3kvZimM5X&t=49)>

Previously, you would execute the `quickstart.sh` script to bootstrap the `cldr-runner` image into a shell and then run your scripts _from the container shell_, e.g. `ansible-playbook /opt/cloudera-deploy/main.yml -e "definition_path=examples/sandbox" -t run,default_cluster -vvv`. While this mode is still certainly possible, the introduction of `ansible-navigator` simplifies these action.

**The most significant change**: the legacy definitions only contain configuration files -- the `definition.yml`, `cluster.yml`, `application.yml`, and `inventory_*` files -- and the legacy `cloudera-deploy` has local playbooks that orchestrated the whole run by calling a "sequence" role in `cloudera.exe`... No longer!

So, what to do? First off...

**Your existing platform configurations -- `definition.yml` and `cluster.yml`, specifically -- remain as they are. No changes are needed.**

What does need to change?

**You need to provide an entrypoint playbook.**

Your project now needs a playbook, ala `main.yml`, to coordinate execution. This change allows for considerable flexibility as to how and when infrastructure and platform runlevels execute - frankly, how and when _any_ tasks, runlevel or otherwise, are run. 

In short, we have moved the responsiblity of managing key sections of the "runlevel" from the `cloudera_deploy` _application_ to the project _itself_. This allows you, on a per-project basis, to define _exactly_ what you want, when you need it. Yet, you still can call on the common, shared order-of-operations for installing Cloudera Manager or spinning up a CDP Public Cloud Datalake that the legacy `cloudera-deploy` once had, rather forced you to have. A simple `ansible.builtin.import_playbook` pragma will include these _collection playbooks_ from the updated `cloudera.exe` collection.

Here is an example. The previous `main.yml` file eventually calls the `cloudera.exe.sequence` role, which in turn calls the _runlevel_ roles.

```yaml
# cloudera.exe.sequence/tasks/main.yml

- name: Validate Infrastructure Configuration
  ansible.builtin.include_role:
    name: cloudera.exe.infrastructure
    tasks_from: validate
    # Truncated for clarity
  
- name: Validate Platform Configuration
  ansible.builtin.include_role:
    name: cloudera.exe.platform
    tasks_from: validate
    # Truncated for clarity

- name: Validate Runtime Configuration
  ansible.builtin.include_role:
    name: cloudera.exe.runtime
    tasks_from: validate
    # Truncated for clarity
```

([See this file in its entirety.](https://github.com/cloudera-labs/cloudera.exe/blob/v1.7.5/roles/sequence/tasks/main.yml))

The _v2.x_ of `cloudera.exe` (and via proxy, `cloudera-deploy`) moves this code from the role _into_ a playbook within `cloudera.exe`.

Here is a _v2.x_ entrypoint playbook. It assumes that you want to handle infrastructure - say, for a sandbox install - as well as the CDP Public Cloud setup. (There is an explicit playbook to teardown.)

```yaml
# cloudera-deploy/public-cloud/aws/datalake/main.yml

- name: Set up the cloudera-deploy variables
  hosts: localhost
  connection: local
  gather_facts: yes
  tasks:
    - name: Read definition variables
      ansible.builtin.include_role:
        name: cloudera.exe.init_deployment
        public: yes
      when: init__completed is undefined
  tags:
    - always

- name: Set up CDP Public Cloud infrastructure (Ansible-based)
  ansible.builtin.import_playbook: cloudera.exe.pbc_infra_setup.yml

- name: Set up CDP Public Cloud (Env and DL example)
  ansible.builtin.import_playbook: cloudera.exe.pbc_setup.yml
```

And the new `cloudera.exe` playbooks?

```yaml
# cloudera.exe/playbooks/pbc_infra_setup.yml

- name: Set up CDP Public Cloud infrastructure (Ansible-based)
  hosts: "{{ target | default('localhost') }}"
  environment: "{{ globals.env_vars }}"
  gather_facts: yes
  tasks:
    - name: Validate CDP Public Cloud infrastructure configuration
      ansible.builtin.import_role:
        name: cloudera.exe.infrastructure
        tasks_from: validate
      tags:
        - validate
        - initialize
        - infra

    - name: Initialize CDP Public Cloud infrastructure setup
      ansible.builtin.import_role:
        name: cloudera.exe.infrastructure
        tasks_from: initialize_setup
      tags:
        - initialize
        - infra

    - name: Set up CDP Public Cloud infrastructure
      ansible.builtin.import_role:
        name: cloudera.exe.infrastructure
        tasks_from: setup
      tags:
        - infra
```

```yaml
# cloudera.exe/playbooks/pbc_setup.yml

- name: Set up CDP Public Cloud
  hosts: "{{ target | default('localhost') }}"
  environment: "{{ globals.env_vars }}"
  gather_facts: yes
  tasks:
    - name: Validate Platform configuration
      ansible.builtin.import_role:
        name: cloudera.exe.platform
        tasks_from: validate
      tags:
        - validate
        - initialize
        - plat
        - run

    - name: Validate Data Services configuration
      ansible.builtin.import_role:
        name: cloudera.exe.runtime
        tasks_from: validate
      tags:
        - validate
        - initialize
        - run

    - name: Initialize Platform setup
      ansible.builtin.import_role:
        name: cloudera.exe.platform
        tasks_from: initialize_setup
      tags:
        - initialize
        - plat
        - run

    - name: Set up Platform
      ansible.builtin.import_role:
        name: cloudera.exe.platform
        tasks_from: setup
      tags:
        - plat
        - run

    - name: Initialize Data Services setup
      ansible.builtin.import_role:
        name: cloudera.exe.runtime
        tasks_from: initialize_setup
      tags:
        - initialize
        - run

    - name: Set up Data Services
      ansible.builtin.import_role:
        name: cloudera.exe.runtime
        tasks_from: setup
      tags:
        - run
```

You can see that instead of calling the role and passing Ansible tags, you call the playbook, which now has _the very same code_ but without the need for some of the tags or the intermediate role, `cloudera.exe.sequence`. In fact, the playbooks in `cloudera.exe` have become the `cloudera.exe.sequence` role.

You don't want to use the infrastructure playbook because you have your own process for establishing infrastructure? Great! Remove the `import_playbook` and call whatever is necessary! So long as you have run `cloudera.exe.init_deployment` in your project's playbook(s) _prior_ to importing any of the _collection playbooks_, you can use the collection playbooks anytime in your project playbooks.

Need to discuss this further? Stop by the [Discussions > Help](https://github.com/cloudera-labs/cloudera.exe/discussions/categories/help)!
