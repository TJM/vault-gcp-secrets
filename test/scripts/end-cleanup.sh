#!/bin/bash -x
helm delete vault-gcr-secrets --namespace "$TARGET_NAMESPACE"
vault delete gcp/roleset/vault-gcr-secrets
sleep 15 # Give vault time to cleanup
