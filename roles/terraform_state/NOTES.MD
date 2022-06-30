# USAGE

```yml
- name: Teardown Cleanup
  hosts: localhost
  gather_facts: yes
  tasks:
    - name: Remove Terraform remote state resources if requested
      when:
        - globals.infra_deployment_engine == 'terraform'
        - globals.terraform.auto_remote_state | bool
        - globals.terraform.state_storage in ['remote_s3']
      ansible.builtin.include_role:
        name: terraform_state
        tasks_from: auto_terraform_state
```