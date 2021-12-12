# Vault GCP Secrets

Use vault agent to keep a `vault_gcp_secrets_roleset` service account key updated as a
Kubernetes secret, either for docker-registry or generic (Opaque). This can be used
for various other pods needing access to Google Services without having a vault agent
for each one. It can also be used as `imagePullSecrets` (for docker type) to retrieve
images from a private GCR repository.

NOTE: We are using this code in the production environment. You may use it at your own risk.

## Prerequisites

* Google Cloud Platform (GCP) Account setup with Vault
* AppRole or Kubernetes authentication to Vault

## Installation

* helm repo add vault-gcp-secrets https://tjm.github.io/vault-gcp-secrets/
* helm repo update
* helm install vault-gcp-secrets/vault-gcp-secrets

NOTE: You will most likely need to set some values, like authentication method, path, etc.

This chart was rougly based on the [vault-secrets-operator](https://github.com/ricoberger/vault-secrets-operator),
which at the time was unable to support GCP secrets engine.
