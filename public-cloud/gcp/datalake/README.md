# CDP Public Cloud - Environment and Datalake on GCP Base Example

> Constructs a CDP Public Cloud Environment and Datalake. Generates via Ansible the GCP infrastructure and CDP artifacts, including SSH key, cross-account Service Account, GCS buckets, etc.

## Requirements

To run, you need:

* Docker (or a Docker alternative)
* GCP Service Account provisioning credentials (set via `GCP_SERVICE_ACCOUNT_FILE`)
* CDP credentials (set via `CDP_PROFILE`)

## Set Up

First, set up your `ansible-navigator` aka `cdp-navigator` environment -- follow the instructions in the [NAVIGATOR document](https://github.com/cloudera-labs/cldr-runner/blob/main/NAVIGATOR.md) in `cloudera-labs/cldr-runner`.

Then, clone this project and change your working directory.

```bash
git clone https://github.com/cloudera-labs/cloudera-deploy.git; cd cloudera-deploy/public-cloud/gcp/datalake
```

## Configure

Set the required environment variables:

```bash
export GCP_SERVICE_ACCOUNT_FILE=absolute-path-to-service-account-file
export CDP_PROFILE=your-cdp-profile
```

Tweak the `definition.yml` parameters to your liking. Notably, you should add and/or change:

```yaml
name_prefix:    ex01      # Keep this short (4-7 characters)
admin_password: "BadPass@1"  # 1 upper, 1 special, 1 number, 8-64 chars.
infra_region:   us-east1
gcp_project_id: gcp-project-id # GCP Project ID
```

> [!NOTE]
> You can override these parameters with any typical Ansible _extra variables_ flags, i.e. `-e admin_password=my_password`. See the [cldr-runner FAQ](https://github.com/cloudera-labs/cldr-runner/blob/main/FAQ.md#how-do-i-add-extra-variables-and-tags-to-ansible-navigator) for details.

### SSH Keys

This definition will create a new SSH keypair on the host in your `~/.ssh` directory if you do not specify a SSH public key.  

If you wish to use an existing SSH key, set `public_key_file` to the key's local path.

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
