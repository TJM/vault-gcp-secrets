#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'

kubectl create serviceaccount --namespace $VAULT_AUTH_NAMESPACE vault

kubectl create clusterrolebinding vault-auth-kube \
  --clusterrole system:auth-delegator \
  --serviceaccount $VAULT_AUTH_NAMESPACE:vault

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: vault-k8s-auth-secret
  namespace: $VAULT_AUTH_NAMESPACE
  annotations:
    kubernetes.io/service-account.name: vault
type: kubernetes.io/service-account-token
EOF

SA_JWT_TOKEN=$(kubectl get secret vault-k8s-auth-secret \
  --namespace $VAULT_AUTH_NAMESPACE \
  --output 'go-template={{ .data.token }}' | base64 --decode)

SA_CA_CRT=$(kubectl config view --raw --minify --flatten \
  --output 'jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)

vault auth enable kubernetes

vault write auth/kubernetes/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="https://kubernetes.default.svc" \
  kubernetes_ca_cert="$SA_CA_CRT" \
  issuer="https://kubernetes.default.svc.cluster.local" \
  token_ttl=900 \
  token_max_ttl=86400
