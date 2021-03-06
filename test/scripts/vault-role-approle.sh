#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'

## Vault Create Role of type Approle
vault write auth/approle/role/vault-gcp-secrets \
  policies=vault-gcp-secrets \
  secret_id_ttl=10m \
  token_num_uses=0 \
  token_ttl=900 \
  token_max_ttl=86400 \

ROLE_ID=$(vault read -format json auth/approle/role/vault-gcp-secrets/role-id | jq -r .data.role_id)
SECRET_ID=$(vault write -format json -f auth/approle/role/vault-gcp-secrets/secret-id | jq -r .data.secret_id)

kubectl create secret generic vault-creds \
  --namespace $TARGET_NAMESPACE \
  --from-literal=role_id="$ROLE_ID" \
  --from-literal=secret_id="$SECRET_ID"
