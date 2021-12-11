#!/bin/bash -xe

## Set SECRET_TYPE from simple 'docker'
[[ $SECRET_TYPE = 'docker' ]] && SECRET_TYPE='kubernetes.io/dockerconfigjson'

## Set AUTH Options
if [[ $AUTH_METHOD = 'kubernetes' ]]; then
  AUTH_OPTIONS='--set vault.authkubernetesRole=vault-gcr-secrets'
elif [[ $AUTH_METHOD = 'approle' ]]; then
  AUTH_OPTIONS='--set vault.credentialSecretName=vault-creds'
else
  echo "UNSUPPORTED AUTH_METHOD: $AUTH_METHOD"
  exit 1
fi

## Set Image options
if [[ -n $KIND_REGISTRY ]]; then
  IMAGE_OPTIONS="--set image.repository=$KIND_REGISTRY/vault-gcr-secrets --set image.tag=test"
fi

helm upgrade --install vault-gcr-secrets ./charts/vault-gcr-secrets \
  --namespace "$TARGET_NAMESPACE" \
  --set vault.address="http://vault.vault.svc.cluster.local:8200" \
  --set vault.authMethod=${AUTH_METHOD} \
  --set vault.authMountPath=auth/${AUTH_METHOD} \
  --set vault.gcpSecretPath=gcp/key/vault-gcr-secrets \
  --set vault.auth.kubernetesRole=${TARGET_ROLE} \
  --set secret.type=${SECRET_TYPE} \
  $AUTH_OPTIONS \
  $IMAGE_OPTIONS


kubectl wait pod -l app.kubernetes.io/instance=vault-gcr-secrets \
  --namespace=$TARGET_NAMESPACE \
  --for=condition=Ready \
  --timeout=30s

sleep 10

kubectl get pods --namespace $TARGET_NAMESPACE

kubectl logs --namespace=$TARGET_NAMESPACE -l app.kubernetes.io/instance=vault-gcr-secrets

kubectl describe secret gcr-secret --namespace=$TARGET_NAMESPACE
