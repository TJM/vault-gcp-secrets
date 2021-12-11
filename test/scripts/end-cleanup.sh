#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'

helm delete vault-gcr-secrets --namespace "$TARGET_NAMESPACE"
vault delete gcp/roleset/vault-gcr-secrets
sleep 15 # Give vault time to cleanup
