# Test Scripts for vault-gcp-secrets

These scripts are designed to work with the [GitHub Workflows](../../.github/workflows).
They can be run directly as well for testing, but require some environment variables to be set.

## Prerequisites

* Google Cloud Account - _(create a free gmail account if you don't have one)_
  * You *do* have to setup billing, but none of the tests create any resources that have cost (just service accounts).
  * RECOMMENDED: Create a "Zero Cost" [budget](https://console.cloud.google.com/billing/014EF7-3D361E-0A6AA5/budgets) ($0.00) and assign it to this project. This ensures that even if something is compromised they can't create resources.
  * Enable the [IAM Service Account Credentials API](https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com)
  * Create a [Google Service Account](https://console.cloud.google.com/iam-admin/serviceaccounts/create) with the following roles
    * Service Account Admin
    * Service Account Key Admin
    * Security Admin (this one actually grants more access than needed, but is an easy solution for now)
  * Get a service account key for this service account
    * In GitHub, create a secret called `GCP_TEST_ACCOUNT` with the contents (json) of the service account key.

## Testing Locally

* Install Vault (`brew install vault`)
* Set Environemt Variables (reference [test workflow](../../.github/workflows/test.yaml))

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_AUTH_NAMESPACE='kube-system'
export TARGET_NAMESPACE='gcr-secrets'
export KIND_REGISTRY=''
```

* Set `GCP_CREDENTIALS` to the contents of the service account key above.

```bash
export GCP_CREDENTIALS="$(cat key.json)"
```

* Set the `AUTH_METHOD` and `SECRET_TYPE` to which test you want to perform. For example:

```bash
export AUTH_METHOD='kubernetes'
export SECRET_TYPE='Opaque'
```

NOTE: The list of environment variables used can be queried with `yq` (wrapper for `jq`).

```bash
yq '[.jobs.test.env, .jobs.test.steps[].env | objects ] | add' .github/workflows/test.yaml
```
