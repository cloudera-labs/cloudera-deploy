# PvC Base Cluster on AWS

> Constructs a CDP Private Cloud Base cluster running on AWS.

## Known Issues

| Issue | Description | Workaround |
|-------|-------------|------------|
| Cluster instances unavailable after the `external_setup.yml` Playbook | The cluster EC2 instances become unavailable after the `external_setup.yml` Playbook. During subsequent playbooks the hosts becomes unreachable and in the EC2 console the VM instances fail the reachability health check. | Restart the EC2 instances via the console. |

## Requirements

To run, you need:

* Docker (or a Docker alternative)
* `ansible-navigator`
* AWS credentials
* CDP Private Cloud Base license file
* SSH key(s) for bastion/jump host and cluster

### Configuration Variables

Configuration is passed via environment variables and an user-facing configuration file.

#### Environment Variables

* Set up the following definition environment variables:

    | Variable | Description | Status |
    |----------|-------------|--------|
    | `SSH_PUBLIC_KEY_FILE` | File path to the SSH public key that will be uploaded to the cloud provider (using the `name_prefix` variable as the key label). E.g. `/Users/example/.ssh/demo_ops.pub` | Mandatory |
    | `SSH_PRIVATE_KEY_FILE` | File path to the SSH private key. E.g. `/Users/example/.ssh/demo_ops` | Mandatory |
    | `CDP_LICENSE_FILE` | File path to a CDP Private Cloud Base license. E.g. `/Users/example/Documents/example_cloudera_license.txt` | Mandatory |
    | `AWS_PROFILE` | The profile label for your AWS credentials. Otherwise, use the associated `AWS_*` parameters. | Mandatory |

#### Configuration file variables

Copy `config-template.yml` to `config.yml` and edit this user-facing configuration file to match your particular deployment.

> [!IMPORTANT]
> `name_prefix` should be 4-7 characters and is the "primary key" for the deployment.

```yaml
name_prefix:       "{{ mandatory }}"                # Unique identifier for the deployment                 
infra_region:      "us-east-2"
domain:            "{{ name_prefix }}.cldr.example" # The deployment subdomain
realm:             "CLDR.DEPLOYMENT"                # The Kerberos realm
common_password:   "Example776"                     # For external services
admin_password:    "Example776"                     # For Cloudera-related services
deployment_tags:
  deployment:   "{{ name_prefix }}"
  deploy-tool:  cloudera-deploy
```

## Execution

## All-in-One

You can run all of the following steps at once, if you wish:

```bash
ansible-navigator run \
    pre_setup.yml \
    external_setup.yml \
    internal_setup.yml \
    base_setup.yml \
    summary.yml \
    -e @definition.yml \
    -e @config.yml
```

### Pre-setup Playbook

This definition-specific playbook includes tasks such as:

* Instructure provisioning
* FreeIPA DNS and KRB services provisioning

Run the following command 

```bash
ansible-navigator run pre_setup.yml \
    -e @definition.yml \
    -e @config.yml
```

Once the pre-setup playbook completes confirm that:

* You can connect to each node via the inventory - see [Confirm SSH Connectivity](#confirm-ssh-connectivity) for help. You can also run `ansible-navigator run validate_dns_lookups.yml` to check connectivity and DNS.
* Connect to FreeIPA UI and login with the `IPA_USER` and `IPA_PASSWORD` credentials in the configuration file. See [Cluster Access](#cluster-access) for details.

### Platform Playbooks

These playbooks configure and deploy PVC Base. They use the infrastructure provisioned.

Tasks include:

* System/host configuration
* Cloudera Manager server and agent installation and configuration
* Cluster template imports

Run the following: 

```bash
# Run the 'external' system configuration
ansible-navigator run external_setup.yml \
    -e @definition.yml \
    -e @config.yml
```

```bash
# Run the 'internal' Cloudera installations and configurations
ansible-navigator run internal_setup.yml \
    -e @definition.yml \
    -e @config.yml
```

```bash
# Run the Cloudera cluster configuration and imports
ansible-navigator run base_setup.yml \
    -e @definition.yml \
    -e @config.yml
```

```bash
# Produce a deployment summary and retrieve the FreeIPA CA certificate
ansible-navigator run summary.yml \
    -e @definition.yml \
    -e @config.yml
```

## Cluster Access

Once the cluster is up, you can access all of the UIs within, including the FreeIPA sidecar, via a SSH tunnel:

```bash
ssh -D 8157 -q -C -N ec2-user@<IP address of jump host>
```

Use a SOCKS5 proxy switcher in your browser (an example is the SwitchyOmega browser extension).

In the SOCKS5 proxy configuration, set _Protocol_ to `SOCKS5`, _Server_ to `localhost`, and _Port_ to `8157`. Ensure the SOCKS5 proxy is active when clicking on the CDP UI that you wish to access.

> [!CAUTION]
> You will get a SSL warning for the self-signed certificate; this is expected given this particular definition as the local FreeIPA server has no upstream certificates. However, you can install this CA certificate to remove this notification.

In addition, you can log into the jump host via SSH and get to any of the servers within the cluster. Remember to forward your SSH key!

```bash
ssh -A -C -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ec2-user@<IP address of jump host>
```

> [!NOTE]
> The above assume you are using the default AMI image set in the Terraform configuration. If not, adjust the SSH user appropriately.

## Teardown

Run the following: 

```bash
ansible-navigator run pre_teardown.yml \
    -e @definition.yml \
    -e @config.yml
```

You can also run the direct Terraform command:

```bash
ansible-navigator exec -- terraform -chdir=tf_proxied_cluster destroy -auto-approve
```

## Troubleshooting

### Confirm SSH Connectivity

Run the following:

```bash
ansible-navigator exec -- ansible -m ansible.builtin.ping -i inventory.yml all
```

This will check to see if the inventory file is well constructed and the hosts are available via SSH.
