#!/usr/bin/env bash
#

echo "$(date) - Entering $0"
if [[ -z "${CODEFRESH_TOKEN}" ]]; then
  echo "ERROR: CODEFRESH_TOKEN env is empty"
  exit 1
fi

VALUES_FILE=/etc/codefresh/runner-values.yaml
if [[ ! -f "${VALUES_FILE}" ]]; then
  echo "ERROR: ${VALUES_FILE} - no such file"
  exit 1
fi

# by default it runs "codefresh runner init"
ACTION=${1:-init}

if [[ "${ACTION}" == "init" ]]; then
  ACTION_PARAMETERS="--exec-demo-pipeline false"
fi

# COMMAND="codefresh runner init -y --values ${VALUES_FILE} --set Token=${CODEFRESH_TOKEN}"
codefresh runner $ACTION -y --values ${VALUES_FILE} $ACTION_PARAMETERS --set Token=${CODEFRESH_TOKEN}

# sleep 1800

