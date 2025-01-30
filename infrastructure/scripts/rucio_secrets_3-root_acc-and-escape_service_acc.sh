#!/bin/bash

# rucio namespace
RUCIO_NS="rucio"

# kubeseal controller namespace
CONTROLLER_NS="sealed-secrets"
CONTROLLER_NAME="sealed-secrets-controller" 

# Output dir
SECRETS_DIR="/root/software/vre/infrastructure/secrets/rucio"

echo " *** Create and apply RUCIO ROOT account secret"

RAW_SECRETS="/root/software/vre/infrastructure/secrets/tmp_local_secrets/rucio-root-account.yaml"
OUTPUT_SECRET="rucio-root-account.yaml"
cat ${RAW_SECRETS} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${OUTPUT_SECRET}
kubectl apply -f ${SECRETS_DIR}/ss_${OUTPUT_SECRET}

echo " *** Create and apply ESCAPE SERVICE ACCOUNT secret"

RAW_SECRETS="/root/software/vre/infrastructure/secrets/tmp_local_secrets/escape-service-account.yaml"
OUTPUT_SECRET="escape-service-account.yaml"
cat ${RAW_SECRETS} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${OUTPUT_SECRET}
kubectl apply -f ${SECRETS_DIR}/ss_${OUTPUT_SECRET}

echo " *** Create and apply RUCIO ADMIN IAM CLIENT details secret"

RAW_SECRETS="/root/software/vre/infrastructure/secrets/tmp_local_secrets/rucio-admin-iam-client.yaml"
OUTPUT_SECRET="rucio-admin-iam-client.yaml"
cat ${RAW_SECRETS} | kubeseal --controller-name=${CONTROLLER_NAME} --controller-namespace=${CONTROLLER_NS} --format yaml --namespace=${RUCIO_NS} > ${SECRETS_DIR}/ss_${OUTPUT_SECRET}
kubectl apply -f ${SECRETS_DIR}/ss_${OUTPUT_SECRET}

echo "Done"
