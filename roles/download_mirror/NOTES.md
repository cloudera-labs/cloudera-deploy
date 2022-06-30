# USAGE

```yml
- name: Prepare for Cloudera Cluster Run
  hosts: localhost
  tags: always
  gather_facts: yes
  tasks:
    - name: Inject Download Mirror if requested
      when:
        - "'teardown' not in ansible_run_tags"
        - "'cluster' in groups"
      ansible.builtin.include_role:
        name: cloudera_deploy
        tasks_from: inject_download_mirror

# TODO: Set timeout waiting for utility VM to be ready
- name: Process Download Mirror on Utility VM
  hosts: cldr_utility
  tags: always
  gather_facts: yes
  tasks:
    - ansible.builtin.include_role:
        name: download_mirror
        tasks_from: prepare_download_mirror.yml

- name: Update relevant Download Mirror Cache listing
  hosts: localhost
  tags: always
  gather_facts: no
  tasks:
    - ansible.builtin.include_role:
        name: download_mirror
        tasks_from: update_download_mirror_cache.yml
```