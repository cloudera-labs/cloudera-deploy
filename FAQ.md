# Frequently Asked Questions

## Where did everything go?

We undertook some serious remodeling, but rest assured, your definitions will still work as they did in the previous version of `cloudera-deploy`.  

So where did everything go? Well...

1. The `quickstart.sh` migrated to `ansible-navigator`. Both applications use a container based on `ansible-runner`, i.e. [`cldr-runner`](https://github.com/cloudera-labs/cldr-runner), yet `ansible-navigator` is configuration-driven and better aligned with how AWX runs Ansible in containers. Plus, `ansible-navigator` brings a nifty UI and the ease of use to handle different execution modes. (And we also migrated `cldr-runner` to use `ansible-builder`, but you can read more about that at the [`cldr-runner`](https://github.com/cloudera-labs/cldr-runner) project.)
1. The original `cloudera-deploy` playbooks moved into `cloudera.exe`. Starting with Ansible `2.11`, [collections can contain playbooks](https://docs.ansible.com/ansible/latest/collections_guide/collections_using_playbooks.html#using-a-playbook-from-a-collection). We call them using `import_playbook` like roles. Using them requires you to first set up your `cloudera-deploy` variables _before_ calling the playbooks.
1. The _run-levels_ still remain, however, the playbooks are more granular. This move promotes composibility and reusability, and we are going to continue to break down the functions and operations within `cloudera-deploy` and the notably the collections that drive this application. We want you to adapt and create your own "deploy" application, one that caters to _your_ needs and operating parameters. Going more granular, more modular is key to this end.

## `ansible-navigator` hangs when I run my playbook. What is going on?

`ansible-navigator` does not handle user prompts when running in the `curses` UI, so actions in your playbook like:

* Vault passwords
* SSH passphrases
* Debugger statements

will not work out-of-the-box. You can enable `ansible-navigator` to run with prompts, but doing so will also disable the UI and instead run its operations using `stdout`.  Try adding:

```bash
ansible-navigator run --enable-prompts ...
```

to your execution.

## How can I view a previous `ansible-navigator` run to debug an issue?

Each example is configured to save execution runs in the project's `runs` directory. You can reload a run by using the `replay` command:

```bash
ansible-navigator replay runs/<playbook name>-<timestamp>.json
```

Then you can use the UI to review the plays, tasks, and inventory for the previous run!

## How can I enable the playbook debugger?

The [playbook debugger](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html) is enabled in `ansible-navigator` by setting the debugger and then enabling prompts. For example,

```bash
ANSIBLE_ENABLE_TASK_DEBUGGER=True ansible-navigator run --enable-prompts main.yml
```

## How can I select just a single subnet using `subnet_filter`, say for a CDE definition?

The various `filters`, like `subnet_filter`, `loadbalancer_subnets_filter`, etc., use [JMESPath](https://jmespath.org/) expressions against a list of subnet objects. Using expression like:

```jmespath
[?contains(subnetName,`pvt`)] | [:1]
```

will limit the list of subnet objects to those with the term `pvt` and then select the first element of that reduced list.