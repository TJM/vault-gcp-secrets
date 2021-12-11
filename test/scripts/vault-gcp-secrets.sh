#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'

vault secrets enable gcp

vault write gcp/config \
  credentials="${GCP_CREDENTIALS}" \
  ttl=300 \
  max_ttl=1800

vault write gcp/roleset/vault-gcr-secrets \
  project="vault-gcr-secrets-6969" \
  secret_type="service_account_key" \
  bindings=-<<EOF
  resource "//cloudresourcemanager.googleapis.com/projects/vault-gcr-secrets-6969" {
    roles = ["roles/viewer"]
  }
EOF

SERVICE_ACCOUNT_EMAIL=$(vault read -field service_account_email gcp/roleset/vault-gcr-secrets)
echo "::set-output name=service_account_email::${SERVICE_ACCOUNT_EMAIL}"

cat <<EOF | vault policy write vault-gcr-secrets -
path "gcp/key/vault-gcr-secrets" {
  capabilities = ["read"]
}
EOF
