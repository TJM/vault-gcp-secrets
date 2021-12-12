#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'

kubectl get pods --namespace vault
echo -e '\n****************************************\n'
kubectl logs --namespace=vault vault-0
echo -e '\n****************************************\n'

kubectl get pods --namespace $TARGET_NAMESPACE
echo -e '\n****************************************\n'
kubectl describe pods --namespace $TARGET_NAMESPACE
echo -e '\n****************************************\n'
kubectl logs --namespace=$TARGET_NAMESPACE -l app.kubernetes.io/instance=vault-gcp-secrets
echo -e '\n****************************************\n'
kubectl describe configmap --namespace=$TARGET_NAMESPACE
echo -e '\n****************************************\n'
