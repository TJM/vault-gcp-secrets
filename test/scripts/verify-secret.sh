#!/bin/bash -xe

if [[ $SECRET_TYPE = "docker" ]]; then
  JSONPATH=".data.\.dockerconfigjson"
else
  JSONPATH=".data.key\.json"
fi

SECRET_EMAIL=$(kubectl get secret --namespace $TARGET_NAMESPACE gcr-secret -o jsonpath="{$JSONPATH}" | base64 --decode | jq -r '.client_email')

if [[ -z $SECRET_EMAIL ]]; then
  echo -e "***** FAIL!\n SECRET_EMAIL is blank"
  exit 1
fi

if [[ $SECRET_EMAIL = $SERVICE_ACCOUNT_EMAIL ]]; then
  echo -e "***** SUCCESS!\n - KUBERNETES_SECRET_EMAIL: ${SECRET_EMAIL}\n -   SERVICE_ACCOUNT_EMAIL: ${SERVICE_ACCOUNT_EMAIL}\n***** SUCCESS!\n"
else
  echo -e "***** FAIL!\n - KUBERNETES_SECRET_EMAIL: ${SECRET_EMAIL}\n -   SERVICE_ACCOUNT_EMAIL: ${SERVICE_ACCOUNT_EMAIL}\n***** FAIL!\n"
  exit 1
fi
