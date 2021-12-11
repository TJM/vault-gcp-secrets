#!/bin/bash -xe
kubectl create serviceaccount --namespace $VAULT_AUTH_NAMESPACE vault-auth

kubectl create clusterrolebinding vault-auth-kube \
  --clusterrole system:auth-delegator \
  --serviceaccount $VAULT_AUTH_NAMESPACE:vault-auth

VAULT_SECRET_NAME=$(kubectl get serviceaccount vault-auth \
  --namespace $VAULT_AUTH_NAMESPACE \
  --output jsonpath="{.secrets[*]['name']}")

SA_JWT_TOKEN=$(kubectl get secret $VAULT_SECRET_NAME \
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
