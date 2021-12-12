# Vault GCR Secrets

Use vault agent to keep a `vault_gcp_secret_roleset` service account key updated as a
docker-registry secret in Kubernetes. This can be used as `imagePullSecrets` to retrieve images
from a private GCR.

NOTE: This is alpha quality, use it at your own risk.

## Prerequisites

* Google Cloud Platform (GCP) Account setup with Vault
* AppRole or Kubernetes authentication to Vault

## Installation

* helm repo add vault-gcr-secrets https://tjm.github.io/vault-gcr-secrets/
* helm repo update
* helm install vault-gcr-secrets/vault-gcr-secrets

NOTE: You will most likely need to set some values, like authentication method, path, etc.

This chart was rougly based on the [vault-secrets-operator](https://github.com/ricoberger/vault-secrets-operator), which at the time was unable to support GCP secrets engine.
