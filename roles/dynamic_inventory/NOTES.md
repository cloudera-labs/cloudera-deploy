# USAGE

```yml
- name: Prepare for Cloudera Cluster Run
  hosts: localhost
  tags: always
  gather_facts: yes
  tasks:
    - name: Load Static Inventory file if present
      when: mgmt is defined | bool
      ansible.builtin.include_role:
        name: cloudera_deploy
        tasks_from: refresh_inventory
      vars:
        include_inventory_file: "{{ init__dynamic_inventory_artefact }}"

- name: Marshal Cloud Deployment
  hosts: localhost
  environment: "{{ globals.env_vars }}"
  gather_facts: yes
  tasks:
    - name: Persist Dynamic Inventory to Definition Path if exists
      tags: always
      when:
        - infra__dynamic_inventory_host_entries is defined
        - infra__dynamic_inventory_host_entries | length > 0
        - init__dynamic_inventory_template is defined
        - init__dynamic_inventory_template | length > 0
      ansible.builtin.include_role:
        name: cloudera_deploy
        tasks_from: persist_dynamic_inventory
        apply:
          tags: always
```

```yml
- name: Teardown Cleanup
  hosts: localhost
  gather_facts: yes
  tasks:
    - name: Remove current Dynamic Inventory file from Definition Path if exists
      ansible.builtin.include_role:
        name: dynamic_inventory
        tasks_from: clean_dynamic_inventory
```