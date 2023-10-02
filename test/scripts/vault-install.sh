#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'

kubectl create namespace vault

helm repo add hashicorp https://helm.releases.hashicorp.com

helm upgrade --install vault hashicorp/vault \
  --namespace=vault \
  --version=0.25.0 \
  --set server.dev.enabled=true \
  --set injector.enabled=false

kubectl wait pod/vault-0 --namespace=vault  --for=condition=Ready --timeout=30s

kubectl port-forward --namespace vault vault-0 8200 &

sleep 2s

vault login root
