#!/usr/bin/env bash
#

echo "$(date) - Entering $0"

VALUES_FILE=/etc/codefresh/runner-values.yaml
if [[ ! -f "${VALUES_FILE}" ]]; then
  echo "ERROR: ${VALUES_FILE} - no such file"
  exit 1
fi

# by default it runs "codefresh runner init"
ACTION=${1:-init}

if [[ "${ACTION}" == "init" ]]; then
  ACTION_PARAMETERS="--exec-demo-pipeline false"

elif [[ "${ACTION}" == "delete" ]]; then
  if [[ -z "$CODEFRESH_TOKEN" ]]; then
    CODEFRESH_TOKEN=$( cat ${VALUES_FILE} | yq -r '.Token // empty')
  fi

  CODEFRESH_HOST=$( cat ${VALUES_FILE} | yq -r '.CodefreshHost // empty')
  if [[ -z "${CODEFRESH_HOST}" ]]; then
    CODEFRESH_HOST=https://g.codefresh.io
  fi
  codefresh auth create-context --url ${CODEFRESH_HOST} --api-key ${CODEFRESH_TOKEN}
  
fi

if [[ -n "${CODEFRESH_TOKEN}" ]]; then
   CODEFRESH_TOKEN_PARAM="--set Token=${CODEFRESH_TOKEN}"
   echo "CODEFRESH_TOKEN env is set"
fi

# COMMAND="codefresh runner init -y --values ${VALUES_FILE} --set Token=${CODEFRESH_TOKEN}"
COMMAND="codefresh runner $ACTION -y --values ${VALUES_FILE} $ACTION_PARAMETERS"
echo "Executing $COMMAND ..."

eval $COMMAND $CODEFRESH_TOKEN_PARAM

#sleep 1800

