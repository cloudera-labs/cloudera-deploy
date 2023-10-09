# PvC Base Cluster on AWS

> Constructs a CDP Private Cloud Base cluster running on AWS.

## Known Issues

| Issue | Description | Workaround |
|-------|-------------|------------|
| Cluster instances unavailable after the `external_setup.yml` Playbook | The cluster EC2 instances become unavailable after the `external_setup.yml` Playbook. During subsequent playbooks the hosts becomes unreachable and in the EC2 console the VM instances fail the reachability health check. | Restart the EC2 instances via the console. |

## Requirements

To run, you need:

* Docker (or a Docker alternative)
* AWS credentials (set via `AWS_PROFILE`)
* CDP Private Cloud Base license file credentials (set via `CDP_LICENSE_FILE`)

### Configuration Variables

Configuration is passed via environment variables and an user-facing configuration file.

#### Environment Variables

* Set up the following definition environment variables:

    | Variable | Description | Status |
    |----------|-------------|--------|
    | `SSH_PUBLIC_KEY_FILE` | File path to the SSH public key that will be uploaded to the cloud provider (using the `name_prefix` variable as the key label). E.g. `/Users/example/.ssh/demo_ops.pub` | Mandatory |
    | `CDP_LICENSE_FILE` | File path to a CDP Private Cloud Base license. E.g. `/Users/example/Documents/example_cloudera_license.txt` | Mandatory |
    | `IPA_USER` | Set this to `admin`. The adminstrator user for FreeIPA.  | Mandatory |
    | `IPA_PASSWORD` | The adminstrator and directory password for FreeIPA | Mandatory |
    | `AWS_PROFILE` | The profile label for your AWS credentials. Otherwise, use the associated `AWS_*` parameters. Used also for remote storage of Terraform state in AWS. | Mandatory |

> **_NOTE:_** For OSX, set the following: `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` to allow the WinRM modules to function.

#### Configuration file variables

Edit the `config.yml` user-facing configuration file to match your particular deployment.

*NOTE:* `name_prefix` should be 4-8 characters and is the "primary key" for the deployment. `owner_prefix` is used in circumstances to differentiate resources such as the SSH key label in the cloud provider and the subdomain(s) for the private DNS service.

```yaml
name_prefix:       "labaw"                          # CHANGE THIS
owner_prefix:      "pvc-base"                        
owner_email:       "example@cloudera.com"            
infra_region:      "eu-west-1"                      
infra_type:        "aws"                            # "aws", "static"
domain:            "{{ owner_prefix }}.cldr.example"   # The private, adhoc subdomain (name_prefix.owner_prefix.cldr.demo)
realm:             "CLDR.EXAMPLE"                      # The Kerberos realm
common_password:   "Example776"                   
admin_password:    "Example776"                   
deployment_tags:
  owner: "{{ owner_prefix }}"
  email: "{{ owner_email }}"
  project: "PvC Base Lab - {{ owner_prefix }}-{{ name_prefix }}"
  enddate: "{{ ('%m%d%Y' | strftime((ansible_date_time.epoch | int) + (90 * 86400))) }}"
  deployment: "{{ name_prefix }}"
  deploy-tool: cloudera-deploy
```

## Execution

### Pre-setup Playbook

This definition-specific playbook includes tasks such as:
* Instructure provisioning
* FreeIPA DNS and KRB services provisioning

Run the following command 

```bash
ansible-navigator run pre_setup.yml \
-e @config.yml \
-e @definition.yml
```

Once the pre-setup playbook completes confirm that:

* You can connect to each node via the inventory - see Confirm SSH Connectivity. Note that a A `validate_dns_lookups.yml` Playbook exists to check connectivity.
* Connect to FreeIPA UI and login with the `IPA_USER` and `IPA_PASSWORD` credentials in the configuration file. See Cluster Access for more details.

### Platform Playbooks

These playbooks configure and deploy PVC Base. They use the infrastructure provisioned (or assigned, if using `static` inventory).

Tasks include:
* System/host configuration
* Cloudera Manager server and agent installation and configuration
* Cluster template imports

Run the following: 

```bash
# Run the 'external' system configuration
ansible-navigator run external_setup.yml \
    -e @config.yml \
    -i inventory_static_<name_prefix>_aws.ini
```

```bash
# Run the 'internal' Cloudera installations and configurations
ansible-navigator run internal_setup.yml \
    -e @config.yml \
    -i inventory_static_<name_prefix>_aws.ini
```

```bash
# Run the Cloudera cluster configuration and imports
ansible-navigator run base_setup.yml \
    -e @config.yml \
    -i inventory_static_<name_prefix>_aws.ini
```

And lastly, the _postfix_:

```bash
ansible-navigator run base_postfix.yml \
    -e @config.yml \
    -i inventory_static_<name_prefix>_aws.ini
```

## Cluster Access

Once the cluster is up, you can access all of the UIs within, including the FreeIPA sidecar, via a SSH tunnel:

```bash
ssh -D <local port for your tunnel, e.g. 8157> -q -C -N <ami user>@<IP address of jump host>
```

and use a SOCKS5 proxy switcher in your browser (an example is the SwitchyOmega browser extension).
In the SOCKS5 proxy configuration, set Protocol to SOCKS5; Server to localhost and Port to 8157. Ensure the SOCKS5 proxy is active when clicking on the CDP UI that you wish to access.

You will get a SSL warning for the self-signed certificate; this is expected given this particular definition.

In addition, you can log into the jump host via SSH and get to any of the servers within the cluster. Remember to forward your SSH key!

```bash
ssh -A -C -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null <ami user>@<IP address of jump host>
```

## Teardown

Run the following: 

```bash
ansible-navigator run pre_teardown.yml \
    -e @config.yml \
    -e @definition.yml \
    -i inventory_static_<name_prefix>_aws.ini
```

You can also run `terraform destroy` within the `tf_deployment_*` directory.

## Troubleshooting

### Confirm SSH Connectivity

Run the following:

```bash
ansible -m ansible.builtin.ping -i inventory_static_<name_prefix>_aws.ini all
```

This will check to see if the inventory file is well constructed, etc.
