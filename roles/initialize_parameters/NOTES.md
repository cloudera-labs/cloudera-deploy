# USAGE

```yml
- name: Prepare for Cloudera Cluster Run
  hosts: localhost
  tags: always
  gather_facts: yes
  tasks:
    - name: Distribute Facts to Inventory Hosts
      when:
        - "'cluster' in groups"
      ansible.builtin.include_role:
        name: cloudera_deploy
        tasks_from: distribute_facts_to_inventory
```