# CDP Public Cloud - Cloudera Machine Learning (CML)

> Constructs a set of Cloudera Machine Learning (CML) workspaces within their own CDP Public Cloud Environment and Datalake. Generates via Ansible the AWS infrastructure and CDP artifacts, including SSH key, cross-account credentials, S3 buckets, etc.

## Requirements

To run, you need:

* Docker (or a Docker clone[^1])
* AWS credentials (set via `AWS_PROFILE`)
* CDP credentials (set via `CDP_PROFILE`)

[^1]: [OrbStack](https://orbstack.dev) works well on OSX.

## Set Up

First, set up your `cdp-navigator` environment -- follow the instructions in the [README](../../README.md).

Then, clone this project and change your working directory.

```bash
git clone https://github.com/cloudera-labs/cloudera-deploy.git; cd cloudera-deploy/public-cloud/aws/cml
```

## Configure

Set the required environment variables:

```bash
export AWS_PROFILE=your-aws-profile
export CDP_PROFILE=your-cdp-profile
```

Tweak the `definition.yml` parameters to your liking. Notably, you should add and/or change:

```yaml
name_prefix:    ex01      # Keep this short (4-7 characters)
admin_password: "Secret"  # 1 upper, 1 special, 1 number, 8-64 chars.
infra_region:   us-east-2
```

NOTE: You can override these parameters with any typical Ansible _extra variables_ flags, i.e. `-e admin_password=my_password`. See the [FAQ](#faq) section.

### SSH Keys

This definition will create a new SSH keypair on the host in your `~/.ssh` directory if you do not specify a SSH public key.  If you wish to use an existing SSH key already loaded into AWS, set `public_key_id` to the key's label. If you wish to use an existing SSH key, but need to have it loaded into AWS, then set `public_key_file` to the key's path.

## Execute

Then set up the CDP Public Cloud by running the playbook:

```bash
ansible-navigator run main.yml
```

## Tear Down

Tear down the CDP Public Cloud by running the playbook:

```bash
ansible-navigator run teardown.yml
```

## FAQ

### Using tags

If you want to run a playbook with a given tag, e.g. `-t infra`, then simply add it as a parameter to the `ansible-navigator` commandline. For example, `ansible-navigator run playbook.yml -t infra`. 

### Using _extra variables_

Like [tags](#using-tags), so you can pass _extra variables_ to `ansible-navigator` and the underlying Ansible command. For example, `ansible-navigator run playbook.yml -e @some_config.yml -e some_var=yes`.

### Using Ansible collection and role paths

Make sure you do _not_ have `ANSIBLE_COLLECTIONS_PATH` or `ANSIBLE_ROLES_PATH` set or `ansible-navigator` will pick up these environment variables and attempt to use them if set! This is great if you want to use host-based collections, e.g. local development, but you need to ensure that you update the `ansible-navigator.yml` configuration file to mount the host collection and/or role directories into the execution environment container.
