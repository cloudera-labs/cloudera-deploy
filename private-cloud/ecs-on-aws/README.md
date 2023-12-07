# PvC ECS Cluster on AWS

> Constructs a CDP Private Cloud Base cluster suitable for enablement in configuring and using Ozone on a Private Cloud ECS Data Services (DS) cluster.

## Requirements

This example requires an execution environment with dependencies to run the automation; and a set of configuration variables.

We provide instructions for using a container based execution environment. 

### Container Execution Environment

1. Create and activate a new `virtualenv` and install `ansible-core` and `ansible-navigator`

    ```bash
    python -m venv ~/cdp-navigator; 

    source ~/cdp-navigator/bin/activate; 

    pip install ansible-core==2.12.10 ansible-navigator==3.4.0
    ```

1. Clone this repository.

    ```bash
    git clone https://github.com/cloudera-labs/cloudera-deploy.git;
    ```

1. Change your working directory to this project.

    ```bash
    cd cloudera-deploy/private-cloud/ecs-on-aws
    ```

1. We currently need to build a local `cldr-runner` image for use as an Execution Environment. _(This is necessary at this point in the release cycle. It will become optional.)_

    ```bash
    ansible-navigator builder build --prune-images -v 3 --tag ghcr.io/cloudera-labs/cldr-runner:pvc-tmp-devel-collections
    ```

This step sometimes takes a ~~number of minutes~~ long time to complete. YMMV.

Once constructed, you can check the image by running `ansible-navigator` and using the prompts to examine:

```bash
ansible-navigator images
```

Or by running the Docker command directly, `docker image ls`.

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
owner_prefix:      "pvc-ecs"                        
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
  project: "PvC ECS Lab - {{ owner_prefix }}-{{ name_prefix }}"
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

These playbooks configure and deploy PVC Base and, optionally, ECS. They use the infrastructure provisioned (or assigned, if using `static` inventory).

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

and use a SOCKS5 proxy switcher in your browser. You will get a SSL warning for the self-signed certificate; this is expected given this particular definition.

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
