#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'

## Vault Create Role of type Kubernetes
vault write auth/kubernetes/role/vault-gcr-secrets \
  bound_service_account_names="vault-gcr-secrets" \
  bound_service_account_namespaces="$TARGET_NAMESPACE" \
  policies=vault-gcr-secrets \
  ttl=300
