#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'


## HELM Options
HELM_OPTIONS=(
  --namespace "${TARGET_NAMESPACE}"
  --set "vault.address=http://vault.vault.svc.cluster.local:8200"
  --set "vault.authMethod=${AUTH_METHOD}"
  --set "vault.gcpSecretPath=gcp/key/vault-gcr-secrets"
)

## Set SECRET_TYPE from simple 'docker'
if [ "${SECRET_TYPE}" = 'docker' ]; then
  HELM_OPTIONS+=(--set "secret.type=kubernetes.io/dockerconfigjson")
else
  HELM_OPTIONS+=(--set "secret.type=Opaque")
fi

## Set AUTH Options
if [ "${AUTH_METHOD}" = 'kubernetes' ]; then
  HELM_OPTIONS+=(--set 'vault.kubernetesRole=vault-gcr-secrets')
elif [ "${AUTH_METHOD}" = 'approle' ]; then
  HELM_OPTIONS+=(--set 'vault.credentialSecretName=vault-creds')
else
  echo "UNSUPPORTED AUTH_METHOD: $AUTH_METHOD"
  exit 1
fi

## Set Image options
echo "KIND_REGISTRY=\'${KIND_REGISTRY}\'"
if [ -n "$KIND_REGISTRY" ]; then
  HELM_OPTIONS+=(--set "image.repository=${KIND_REGISTRY}/vault-gcr-secrets" --set 'image.tag=test')
fi

helm upgrade --install vault-gcr-secrets ./charts/vault-gcr-secrets "${HELM_OPTIONS[@]}"

kubectl wait pod -l app.kubernetes.io/instance=vault-gcr-secrets \
  --namespace=$TARGET_NAMESPACE \
  --for=condition=Ready \
  --timeout=30s

sleep 10

kubectl get pods --namespace $TARGET_NAMESPACE

kubectl logs --namespace=$TARGET_NAMESPACE -l app.kubernetes.io/instance=vault-gcr-secrets

kubectl describe secret gcr-secret --namespace=$TARGET_NAMESPACE
