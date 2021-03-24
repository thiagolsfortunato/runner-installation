#!/usr/bin/env bash
#

echo "$(date) - Entering $0"

VALUES_FILE=/etc/codefresh/runner-values.yaml
if [[ ! -f "${VALUES_FILE}" ]]; then
  echo "ERROR: ${VALUES_FILE} - no such file"
  exit 1
fi


if [[ -z "$CODEFRESH_TOKEN" ]]; then
  CODEFRESH_TOKEN=$( cat ${VALUES_FILE} | yq -r '.Token // empty')
fi

CODEFRESH_HOST=$( cat ${VALUES_FILE} | yq -r '.CodefreshHost // empty')
if [[ -z "${CODEFRESH_HOST}" ]]; then
  CODEFRESH_HOST=https://g.codefresh.io
fi
echo "Creating codefresh auth context for Codefresh Host ${CODEFRESH_HOST}"
codefresh auth create-context --url ${CODEFRESH_HOST} --api-key ${CODEFRESH_TOKEN}

# by default it runs "codefresh runner init"
ACTION=${1}

if [[ "${ACTION}" == "init" ]]; then
  ACTION_PARAMETERS="--exec-demo-pipeline false"

fi

if [[ -n "${CODEFRESH_TOKEN}" ]]; then
   CODEFRESH_TOKEN_PARAM="--set Token=${CODEFRESH_TOKEN}"
   echo "CODEFRESH_TOKEN env is set"
fi

case "${ACTION}" in
  delete)
    runtime_context=$(yq -r .Context ${VALUES_FILE})
    runtime_namespace=$(yq -r .Namespace ${VALUES_FILE})
    runtime_name="${runtime_context}_${runtime_namespace}"
    codefresh runner $ACTION --force --values ${VALUES_FILE} --name ${runtime_name} --kube-namespace ${runtime_namespace} 
    ;;
  *)
    if [[ -n "${ACTION}" ]]; then
      # COMMAND="codefresh runner init -y --values ${VALUES_FILE} --set Token=${CODEFRESH_TOKEN}"
      COMMAND="codefresh runner $ACTION --force --values ${VALUES_FILE} $ACTION_PARAMETERS"
      echo "Executing $COMMAND ..."
      eval $COMMAND $CODEFRESH_TOKEN_PARAM
      tail -f /dev/null
    fi
    ;;
esac
