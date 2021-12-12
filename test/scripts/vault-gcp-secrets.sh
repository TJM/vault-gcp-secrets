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

PROJECT_ID=$(echo "${GCP_CREDENTIALS}" | jq -r '.project_id')
echo "::set-output name=project_id::${PROJECT_ID}"

vault write gcp/roleset/vault-gcp-secrets \
  project="${PROJECT_ID}" \
  secret_type="service_account_key" \
  bindings=-<<EOF
  resource "//cloudresourcemanager.googleapis.com/projects/${PROJECT_ID}" {
    roles = ["roles/viewer"]
  }
EOF

SERVICE_ACCOUNT_EMAIL=$(vault read -field service_account_email gcp/roleset/vault-gcp-secrets)
echo "::set-output name=service_account_email::${SERVICE_ACCOUNT_EMAIL}"

cat <<EOF | vault policy write vault-gcp-secrets -
path "gcp/key/vault-gcp-secrets" {
  capabilities = ["read"]
}
EOF
