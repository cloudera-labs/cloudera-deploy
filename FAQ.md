# Frequently Asked Questions

Be sure to check out the [Discussions > Help](https://github.com/cloudera-labs/cloudera-deploy/discussions/categories/help) category for the latest answers. 

## Where did everything go?

The project undertook some serious remodeling, but rest assured, your definitions will still work as they did in the previous version of `cloudera-deploy`.  

Okay, but where did everything go? Well...

1. The `quickstart.sh` migrated to `ansible-navigator`. Both of these applications use a container based on `ansible-runner`, i.e. [`cldr-runner`](https://github.com/cloudera-labs/cldr-runner), to execute the playbooks, yet `ansible-navigator` is configuration-driven and better aligned with how AWX runs Ansible in containers. Also, `ansible-navigator` brings a nifty text-based UI (TUI) and the ease of use to handle different execution modes.
  
    We also migrated `cldr-runner` to use `ansible-builder`, but you can read more about that effort at the [`cldr-runner`](https://github.com/cloudera-labs/cldr-runner) project.

1. The original `cloudera-deploy` playbooks moved into `cloudera.exe`. Starting with Ansible `2.11`, [collections can contain playbooks](https://docs.ansible.com/ansible/latest/collections_guide/collections_using_playbooks.html#using-a-playbook-from-a-collection). We call the playbooks using `import_playbook` like roles.

    > [!IMPORTANT]
    > If you are developing your own project playbooks, you must first set up your `cloudera-deploy` variables _before_ calling the playbooks by running the `cloudera.exe.init_deployment` role.

1. The _runlevels_ still remain; you can still use `-t infra` for example. However, the playbooks themselves are more granular and overall set up and tear down processes are now separate playbooks.
  
    This change promotes composibility and reusability, and we are going to continue to break apart the functions and operations within `cloudera-deploy` and -- most importantly -- the collections that drive this application. We fully expect that you will want to adapt and create your own "deploy" application, one that caters to _your_ needs and operating parameters. Switching to a more granular, more modular approach is key to this objective.

## How do I run my `cloudera-deploy` V1 playbooks in `ansible-navigator`?

See the [Migration V1](MIGRATION_V1.md) document for details.

## How can I view a previous `ansible-navigator` run to debug an issue?

Each example is configured to save execution runs in the project's `runs` directory. You can reload a run by using the `replay` command:

```bash
ansible-navigator replay runs/<playbook name>-<timestamp>.json
```

Then you can use the UI to review the plays, tasks, and inventory for the previous run!

## How can I select just a single subnet using `subnet_filter`, say for a CDE definition?

The various `filters`, like `subnet_filter`, `loadbalancer_subnets_filter`, etc., use [JMESPath](https://jmespath.org/) expressions against a list of subnet objects. Using expression like:

```jmespath
[?contains(subnetName,`pvt`)] | [:1]
```

will limit the list of subnet objects to those with the term `pvt` and then select the first element of that reduced list.

You can [test sample filters](https://play.jmespath.org/?u=45e4d839-15f9-4569-9490-20a2cbc0cc88) using this example on the JMESPath Playground (link goes to a preloaded playground):

```json
[
  {
    "availabilityZone": "us-east-2c",
    "cidr": "10.10.64.0/19",
    "subnetId": "subnet-0123",
    "subnetName": "sbnt-pub-2"
  },
  {
    "availabilityZone": "us-east-2a",
    "cidr": "10.10.0.0/19",
    "subnetId": "subnet-1234",
    "subnetName": "sbnt-pub-0"
  },
  {
    "availabilityZone": "us-east-2c",
    "cidr": "10.10.160.0/19",
    "subnetId": "subnet-2345",
    "subnetName": "sbnt-pvt-2"
  },
  {
    "availabilityZone": "us-east-2b",
    "cidr": "10.10.128.0/19",
    "subnetId": "subnet-3456",
    "subnetName": "sbnt-pvt-1"
  },
  {
    "availabilityZone": "us-east-2b",
    "cidr": "10.10.32.0/19",
    "subnetId": "subnet-4567",
    "subnetName": "sbnt-pub-1"
  },
  {
    "availabilityZone": "us-east-2a",
    "cidr": "10.10.96.0/19",
    "subnetId": "subnet-5678",
    "subnetName": "sbnt-pvt-0"
  }
]
```
