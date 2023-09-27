# cloudera-deploy - Automation Quickstarts and Examples for the Cloudera Data Platform (CDP)

`cloudera-deploy` is a rich set of examples and quickstart projects for deploying and managing the Cloudera Data Platform (CDP). Its scope includes [**Cloudera Data Platform (CDP) Public Cloud, Private Cloud, and Data Services**](https://www.cloudera.com/products/cloudera-data-platform.html) and the software lifecycle of these platforms and the applications that work upon and with them. 

You can use the definitions and projects in `cloudera-deploy` as your entrypoint for getting started with CDP. These resources use straightforward configurations and playbooks to instruct the automation functions, yet each is extensible and highly configurable. 

`cloudera-deploy` is designed to not only get you up and running quickly with CDP, but also to showcase the underlying toolsets and libraries. These projects demonstrate what you can build and layout a great foundation for your own entrypoints, CI/CD pipelines, integrations, and general platform and application operations.

# Quickstart

The definitions and projects in `cloudera-deploy` are designed to run with `ansible-navigator` and other _Execution Environment_-based tools. 

Follow these steps to get started:

1. [Install `ansible-navigator`](#installation-and-usage)
1. [Check your requirements](#requirements)
1. [Select and configure your project](#catalog)
1. [Set your credentials](#credentials)
1. [Run your project](#execution)

If you need help, check out the [Frequently Asked Questions](FAQ.md), the [FAQ for cldr-runner](https://github.com/cloudera-labs/cldr-runner/blob/main/FAQ.md), and drop by the [Discussions > Help](https://github.com/cloudera-labs/cloudera-deploy/discussions/categories/help) board.

# Catalog

The catalog of projects, examples, and definitions currently covers CDP Public Cloud for AWS. CDP Private Cloud and individual Data Services, Public and Private, as well as Public Cloud deployments to Azure and Google Cloud, are coming soon.

| Project | Platform | CSP | Description |
|---------|----------|-----|-------------|
| [`datalake`](public-cloud/aws/datalake/README.md) | public cloud | AWS | **Constructs a CDP Public Cloud Environment and Datalake.** Generates via Ansible the AWS infrastructure and CDP artifacts, including SSH key, cross-account credentials, S3 buckets, etc. |
| [`datalake-tf`](public-cloud/aws/datalake-tf/README.md) | public cloud | AWS | **Constructs a CDP Public Cloud Environment and Datalake.** Uses the [terraform-cdp-modules](https://github.com/cloudera-labs/terraform-cdp-modules), called via Ansible, to generate the AWS infrastructure pre-requisite resources and the CDP artifacts. |
| [`cde`](public-cloud/aws/cde/README.md) | public cloud | AWS | **Constructs a set of Cloudera Data Engineering (CDE) workspaces within their own CDP Public Cloud Environment and Datalake.** Generates via Ansible the AWS infrastructure and CDP artifacts, including SSH key, cross-account credentials, S3 buckets, etc. |
| [`cdf`](public-cloud/aws/cdf/README.md) | public cloud | AWS | **Constructs a set of Cloudera Data Flow (CDF) workspaces and data hubs  within their own CDP Public Cloud Environment and Datalake.** Generates via Ansible the AWS infrastructure and CDP artifacts, including SSH key, cross-account credentials, S3 buckets, etc. |
| [`cml`](public-cloud/aws/cml/README.md) | public cloud | AWS | **Constructs a set of Cloudera Machine Learning (CML) workspaces within their own CDP Public Cloud Environment and Datalake.** Generates via Ansible the AWS infrastructure and CDP artifacts, including SSH key, cross-account credentials, S3 buckets, etc. |

# Roadmap

If you want to see what we are working on or have pending, check out:

* the [Milestones](https://github.com/cloudera-labs/cloudera-deploy/milestones) and [active issues](https://github.com/cloudera-labs/cloudera-deploy/issues?q=is%3Aissue+is%3Aopen+milestone%3A*) to see our current activity,
* the [issue backlog](https://github.com/cloudera-labs/cloudera-deploy/issues?q=is%3Aopen+is%3Aissue+no%3Amilestone) to see what work is pending or under consideration, and
* the [Ideas](https://github.com/cloudera-labs/cloudera-deploy/discussions/categories/ideas) discussion to see what we are considering.

Are we missing something? Let us know by [creating a new issue](https://github.com/cloudera-labs/cloudera-deploy/issues/new) or [posting a new idea](https://github.com/cloudera-labs/cloudera-deploy/discussions/new?category=ideas)!

# Contributions

For more information on how to get involved with the `cloudera-deploy` project, head over to [CONTRIBUTING.md](CONTRIBUTING.md).

# Requirements

`cloudera-deploy` itself is not an application, but its projects and examples expect to run within an _execution environment_ called `cldr-runner`. This _execution environment_ typically is a container that encapsulates the runtimes, libraries, Python and system dependencies, and general configurations needed to run an Ansible- and Terraform-enable project. 

> [!NOTE]
> It is worth pointing out that you don't _have_ to use a container, but setting up a local execution environment is out-of-scope of `cloudera-deploy`; the projects in `cloudera-deploy` will run in any _execution environment_, for example [AWX](https://github.com/ansible/awx)/[Red Hat Ansible Automation Platform (AAP)](https://www.redhat.com/en/technologies/management/ansible). If you want to learn more about setting up a local execution environment, head over to [cloudera-labs/cldr-runner](https://github.com/cloudera-labs/cldr-runner).

The `cloudera-deploy` projects and their playbooks are built with the automation resources provided by `cldr-runner`, notably, but not exclusively:

* [`cloudera.cloud`](https://github.com/cloudera-labs/cloudera.cloud) - Cloudera Data Platform (CDP) for Public Cloud
* [`cloudera.cluster`](https://github.com/cloudera-labs/cloudera.cluster) - Cloudera Data Platform (CDP) for Private Cloud and Cloudera Manager (CM)
* [`cloudera.exe`](https://github.com/cloudera-labs/cloudera.exe) - Runlevel Management and Utilities for Cloudera Data Platform (CDP)
* [`cdp-tf-quickstarts`](https://github.com/cloudera-labs/cdp-tf-quickstarts) - CDP quickstarts using the Terraform Module for CDP Prerequisites
* [`terraform-cdp-modules`](https://github.com/cloudera-labs/terraform-cdp-modules) - Terraform Modules for CDP Prerequisites

Besides these resources within `cldr-runner`, `cloudera-deploy` projects generally will need one or more of the following **credentials**:

## CDP Public Cloud

For CDP Public Cloud, you will need an _Access Key_ and _Secret_ set in your user profile. The underlying automation libraries use your `default` profile unless you instruct them otherwise. See [Configuring CDP client with the API access key](https://docs.cloudera.com/cdp-public-cloud/cloud/cli/topics/mc-cli-generating-an-api-access-key.html) for further details. 

## Cloud Providers

For Azure and AWS infrastructure, the process is similar to CDP Public Cloud, and these parameters may likewise be overridden.

For Google Cloud, we suggest you issue a _credentials file_, store it securely in your profile, and then reference that file as needed by a project's configuration, as this works best with both CLI and Ansible Gcloud interactions.

## CDP Private Cloud 

For CDP Private Cloud you will need a valid Cloudera license file in order to download the software from the Cloudera repositories. We suggest you store this file in your user profile in `~/.cdp/` and reference that file as needed by a project's configuration.

If you are also using Public Cloud infrastructure to host your CDP Private Cloud clusters, then you will need those credentials as well.

# Installation and Usage

To use the projects in `cloudera-deploy`, you need to first set up `ansible-navigator`.

> [!IMPORTANT]
> Please note each OS has slightly different requirements for installing `ansible-navigator`. :woozy_face: Read more about [installing `ansible-navigator`](https://ansible.readthedocs.io/projects/navigator/installation/#install-ansible-navigator).

1. Create and activate a new Python `virtualenv`.

   You can name your virtual environment anything you want; by convention, we like to call it `cdp-navigator`.

   ```bash
   python -m venv ~/cdp-navigator; source ~/cdp-navigator/bin/activate;
   ```

   This step is _highly recommended_ yet optional.

2. Install the latest `ansible-core` and `ansible-navigator`.

   These tools can be the latest versions, as the actual execution versions are encapsulated in the _execution environment_ container.

   ```bash
    pip install ansible-core ansible-navigator
   ```

> [!NOTE]
> Further details can be found in the [NAVIGATOR document](https://github.com/cloudera-labs/cldr-runner/blob/main/NAVIGATOR.md) in `cloudera-labs/cldr-runner`.

Then, clone this project.

```bash
git clone https://github.com/cloudera-labs/cloudera-deploy.git; cd cloudera-deploy;
```

## Execution Engine

`ansible-navigator` can use either `docker` or `podman`. Either way, you will need a container runtime on your host.

### Confirm your Docker service

Check that `docker` is available by running the following command to list any active Docker containers.

```bash
docker ps -a
```

If it is not running, please check your prerequisites process for Docker to install, start, and test the service.

## Credentials

To check that your various credentials are available and valid -- that they _match the expected accounts_ -- you can use `ansible-navigator` within your project and compare the user and account IDs produced with those found in the browser UI of the associated service.

> [!IMPORTANT]
> All of the instructions below assume that your project is using the correct CSP-flavored image of `cldr-runner`. If in doubt, you can use the `full` image which has all supported CSP resources.

### CDP Public Cloud

```
ansible-navigator exec -- cdp iam get-user
```

> [!NOTE]
> If you do not yet have a CDP Public Cloud credential, follow [these instructions](https://docs.cloudera.com/cdp-public-cloud/cloud/cli/topics/mc-cli-generating-an-api-access-key.html) on the Cloudera website.

See [CDP CLI](https://docs.cloudera.com/cdp-public-cloud/cloud/cli/topics/mc-cdp-cli.html) for further details.

### AWS

```bash
ansible-navigator exec -- aws iam get-user
```

See [AWS account requirements](https://docs.cloudera.com/cdp-public-cloud/cloud/requirements-aws/topics/mc-requirements-aws.html) for further details.

### Azure

```bash
ansible-navigator exec -- az account list
```

> [!NOTE]
> If you cannot list your Azure accounts, consider using `az login` to refresh your local, i.e. host, credential.

See [Azure subscription requirements](https://docs.cloudera.com/cdp-public-cloud/cloud/requirements-azure/topics/mc-azure-requirements.html) for further details.

### GCP

```bash
ansible-navigator exec -- gcloud auth list
```

> [!NOTE]
> You need a provisioning Service Account for GCP setup (typically referenced by the `gcloud_credential_file` entry). If you do not yet have a Provisioning Service Account you can [learn more](https://docs.cloudera.com/cdp-public-cloud/cloud/requirements-gcp/topics/mc-gcp-permissions.html) on the Cloudera website.

See [GCP requirements](https://docs.cloudera.com/cdp-public-cloud/cloud/requirements-gcp/topics/mc-requirements-gcp.html) for further details.

## Execution

All of the definitions and projects in `cloudera-deploy` are designed to work with `ansible-navigator`. Each project has discrete instructions on what and how to run, but in general, you will end up executing some form of the `ansible-navigator run` subcommand, like:

```bash
ansible-navigator run main.yml -e @config.yml -t plat
```

Occasionally, the instructions may ask you to run an individual module, such as `ansible-navigator exec -- ansible some_group -m ping`.  You can learn more about the [available subcommands](https://ansible.readthedocs.io/projects/navigator/subcommands/) on the `ansible-navigator` website.

> [!NOTE]
> If you want to check out what's in the container, or use the container directly, run `ansible-navigator exec -- /bin/bash`!

### Logs

The projects are configured to log their activities. In each, you will find a `runs/` directory that houses all of the runtime artifacts of `ansible-navigator` and `ansible-runner` (the Ansible application and interface that does the actual Ansible command dispatching).

The log files are structured (JSON) and are indexed by playbook and timestamp. If you want to review, rather _replay_, you can load them into `ansible-navigator`:

```bash
ansible-navigator replay <playbook execution run file>.json
```

### Upgrades

The `cldr-runner` image updates fairly often to include the latest libraries, new features and fixes. Depending on how `ansible-navigator` is configured (see the `ansible-navigator.yml` file), the application  will check for an updated container image only if it is missing.

You can easily change this behavior; change your `ansible-navigator.yml` configuration in your project to:

```yaml
ansible-navigator:
  execution-environment:
    pull:
      policy: always
```

Or use the CLI flags `--pp` or `--pull-policy` and set the value to `always`. 

You can read more about [updating this configuration](https://ansible.readthedocs.io/projects/navigator/settings/#pull-policy) on the `ansible-navigator` website. 

# Troubleshooting

If you need help, here are some resources:

* [Frequently Asked Questions for `cloudera-deploy`](FAQ.md)
* [Frequently Asked Questions for `cldr-runner` and `ansible-navigator`](https://github.com/cloudera-labs/cldr-runner/blob/main/FAQ.md)

Be sure to stop by the [Discussions > Help](https://github.com/cloudera-labs/cloudera-deploy/discussions/categories/help) board!

# License and Copyright

Copyright 2023, Cloudera, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
