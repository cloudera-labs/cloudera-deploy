# Cloudera Deploy

## cdp-navigator

`cloudera-deploy` uses `ansible-navigator` to manage and execute the deployment definitions. Setting up `ansible-navigator` is straightforward; create and activate a new `virtualenv` and install the latest `ansible-core` and `ansible-navigator`.

```bash
python -m venv ~/cdp-navigator; source ~/cdp-navigator/bin/activate; pip install ansible-core ansible-navigator
```

