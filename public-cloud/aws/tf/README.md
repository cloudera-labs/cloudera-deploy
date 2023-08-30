# CDP Public Cloud - Environment and Datalake Base Example

> Constructs a CDP Public Cloud Environment and Datalake. Uses the [terraform-cdp-modules](https://github.com/cloudera-labs/terraform-cdp-modules), called via Ansible, to generate the AWS infrastructure pre-requisite resources and the CDP artifacts.

> **NOTE:** This deployment example does not use a `definition.yml` based configuration file. Instead a standard Ansible extra vars configuration file is used.

## Requirements

To run, you need:

* Docker (or a Docker clone[^1])
* AWS credentials (set via `AWS_PROFILE`)
* CDP credentials (set via `CDP_PROFILE`)

[^1]: For example, [OrbStack](https://orbstack.dev) works well on OSX.

## Set Up

First, set up your `ansible-navigator` aka `cdp-navigator` environment -- follow the instructions in the top-level [README](../../../README.md#setting-up-ansible-navigator).

Then, clone this project and change your working directory.

```bash
git clone https://github.com/cloudera-labs/cloudera-deploy.git; cd cloudera-deploy/public-cloud/aws/base
```

## Configure

Set the required environment variables:

```bash
export AWS_PROFILE=your-aws-profile
export CDP_PROFILE=your-cdp-profile
```

Tweak the `config.yml` parameters to your liking. Notably, you should add and/or change:

```yaml
name_prefix:    ex01      # Keep this short (4-7 characters)
infra_region:   us-east-2 # CSP region for infra

deployment_template: public # Specify the deployment pattern below. Options are public, semi-private or private
```

NOTE: You can override these parameters with any typical Ansible _extra variables_ flags, i.e. `-e name_prefix=ex01`. See the [FAQ](../../../FAQ.md#how-to-i-add-extra-variables-and-tags-to-ansible-navigator) for details.

### SSH Keys

This definition will create a new SSH keypair on the host of the name `<name_prefix>-ssh-key.{pem,pub}`. This is stored in the `./pbc_infra_tf` directory. A AWS Keypair will be created using the generated public key.

## Execute

Then set up the CDP Public Cloud by running the playbook:

```bash
ansible-navigator run main.yml
```

### Terraform resource files 

The Terraform root module resource files run by the playbook are in the `./pbc_infra_tf/` (for cloud infrastructure deployment) `./pbc_deploy_tf/` (CDP deployment) sub-directories. 

Standard Terraform commands - e.g. `terraform output`, `terraform console`, can be run from within these directories.

## Tear Down

Tear down the CDP Public Cloud by running the playbook:

```bash
ansible-navigator run teardown.yml
```
