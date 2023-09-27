# Contributing to cloudera-deploy

Thank you for considering contributions to the `cloudera-deploy` project!

# Submitting a pull request

You can start work on issues that are not yet part of a [Milestone](https://github.com/cloudera-labs/cloudera-deploy/milestones) -- anything in our issue tracker that isn't assigned to a Milestone is considered the [backlog](https://github.com/cloudera-labs/cloudera-deploy/issues?q=is%3Aopen+is%3Aissue+no%3Amilestone). 

Before you start working, please announce that you want to do so by commenting on the issue. _([Create an issue](https://github.com/cloudera-labs/cloudera-deploy/issues/new?labels=enhancement) if there isn't one yet, and you can also check out our [Discussions](https://github.com/cloudera-labs/cloudera-deploy/discussions) for ideas.)_ We try to ensure that all active work is assigned to a Milestone in order to keep our backlog accurate.

**When your work is ready for review, create a branch in your own forked repository from the `devel` branch and submit a pull request against `devel`, referencing your the issue.**

As a _best practice_, you can prefix your branches with:

|prefix|Description|Example|
|------|-----------|-------|
|`feature/`|A new feature or changes existing to existing code or documentation|`feature/update-some-params`|
|`fix/`|A non-urgent bug fix|`fix/refactor-some-params`|
|`hotfix/`|An urgent bug fix|`hotfix/patch-insecure-params`|

> [!NOTE]
> :fire_extinguisher: A **hotfix** should branch from `main`. It will then be committed to both the `main` and `devel` branches.

# Signing your commits

Note that we require signed commits inline with [Developer Certificate of Origin](https://developercertificate.org/) best-practices for open source collaboration.

A signed commit is a simple one-liner at the end of your commit message that states that you wrote the patch or otherwise have the right to pass the change into open source.  Signing your commits means you agree to:

```
Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
660 York Street, Suite 102,
San Francisco, CA 94110 USA

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.


Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

(See [developercertificate.org](https://developercertificate.org/))

To agree, make sure to add line at the end of every git commit message, like this:

```
Signed-off-by: John Doe <jdoe@example.com>
```

> [!NOTE]
> :rocket: TIP! Add the sign-off automatically when creating the commit via the `-s` flag, e.g. `git commit -s`.

# Have questions? Opinions? Comments?

Come find us on our [Discussions](https://github.com/cloudera-labs/cloudera-deploy/discussions)!
