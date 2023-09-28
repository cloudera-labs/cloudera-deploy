# CDP Public Cloud - Cloudera Data Flow (CDF)

> Constructs a set of Cloudera Data Flow (CDF) workspaces and data hubs  within their own CDP Public Cloud Environment and Datalake. Generates via Ansible the AWS infrastructure and CDP artifacts, including SSH key, cross-account credentials, S3 buckets, etc.

## Requirements

To run, you need:

* Docker (or a Docker alternative)
* AWS credentials (set via `AWS_PROFILE`)
* CDP credentials (set via `CDP_PROFILE`)

## Set Up

First, set up your `ansible-navigator` aka `cdp-navigator` environment -- follow the instructions in the [NAVIGATOR document](https://github.com/cloudera-labs/cldr-runner/blob/main/NAVIGATOR.md) in `cloudera-labs/cldr-runner`.

Then, clone this project and change your working directory.

```bash
git clone https://github.com/cloudera-labs/cloudera-deploy.git; cd cloudera-deploy/public-cloud/aws/cdf
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

> [!NOTE]
> You can override these parameters with any typical Ansible _extra variables_ flags, i.e. `-e admin_password=my_password`. See the [cldr-runner FAQ](https://github.com/cloudera-labs/cldr-runner/blob/main/FAQ.md#how-do-i-add-extra-variables-and-tags-to-ansible-navigator) for details.

### SSH Keys

This definition will create a new SSH keypair on the host in your `~/.ssh` directory if you do not specify a SSH public key.  If you wish to use an existing SSH key already loaded into AWS, set `public_key_id` to the key's label. If you wish to use an existing SSH key, but need to have it loaded into AWS, then set `public_key_file` to the key's path.

## Execute

Then set up the CDP Public Cloud by running the playbook:

```bash
ansible-navigator run main.yml
```

To deploy an example CDF ReadyFlow, run next the playbook:

```bash
ansible-navigator run application.yml
```

## Tear Down

Tear down the CDP Public Cloud by running the playbook:

```bash
ansible-navigator run teardown.yml
```
