#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x
IFS=$'\n\t'

if [ "${SECRET_TYPE}" = "docker" ]; then
  SECRET_EMAIL=$(kubectl get secret gcr-secret --namespace ${TARGET_NAMESPACE} -o jsonpath="{.data.\.dockerconfigjson}" | base64 --decode | jq -r '.auths."gcr.io".password | fromjson .client_email')
else
  SECRET_EMAIL=$(kubectl get secret gcr-secret --namespace ${TARGET_NAMESPACE} -o jsonpath="{.data.key\.json}" | base64 --decode | jq -r '.client_email')
fi


if [ -z "${SECRET_EMAIL}" ]; then
  echo -e "***** FAIL!\n SECRET_EMAIL is blank"
  exit 1
fi

if [ "${SECRET_EMAIL}" = "${SERVICE_ACCOUNT_EMAIL}" ]; then
  echo -e "***** SUCCESS!\n - KUBERNETES_SECRET_EMAIL: ${SECRET_EMAIL}\n -   SERVICE_ACCOUNT_EMAIL: ${SERVICE_ACCOUNT_EMAIL}\n***** SUCCESS!\n"
else
  echo -e "***** FAIL!\n - KUBERNETES_SECRET_EMAIL: ${SECRET_EMAIL}\n -   SERVICE_ACCOUNT_EMAIL: ${SERVICE_ACCOUNT_EMAIL}\n***** FAIL!\n"
  exit 1
fi
