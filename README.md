# Codefresh runner installation - helm chart

This helm chart will install Codefresh runner into your Kubernetes cluster. 
For additional information regarding "Codefresh Runner" look here: [https://codefresh.io/docs/docs/administration/codefresh-runner/](https://codefresh.io/docs/docs/administration/codefresh-runner/)


This helm chart support both Helm2 and Helm3.

## Prerequisite
1. If you are working on air-gapped environment (without internet access), make sure to push the image "codefresh/cli" into your local registry before proceeding with the installation.

2. Before you start to install this helm chart make sure you have a Codefresh API token, follow this doc for HOW-TO generate it: [https://codefresh.io/docs/docs/integrations/google-marketplace/#step-0---create-a-codefresh-api-key](https://codefresh.io/docs/docs/integrations/google-marketplace/#step-0---create-a-codefresh-api-key)
3. Clone this repo and pack the helm chart by executing:

`git clone https://github.com/codefresh-io/runner-installtion.git`

`helm package runner-installation`

## Installation
1. Edit the file `values.yaml`. VERY IMPORTENT!!!

`helm install --namespace <NAMESPACE> <RELEASE-NAME> runner-installation-0.1.0.tgz`

## values.yaml parameters - all fields are MANDATORY
|                      |Description                                 |Default                 |
|----------------------|--------------------------------------------|------------------------|
|env.codefreshToken    |"Codefresh API Token."                      |<TOKEN_ID_YOU_GENERATED>|
|env.codefreshAgentName|"Codefresh agent name."                     |"defaultAgent"          |
|env.codefreshURL      |"Codefresh custom url, for on-prem install".|"https://g.codefresh.io"|
|image.repository      |"The codefresh-cli image path".             |codefresh/cli           |




env:
  codefreshToken: <TOKEN_ID_YOU_GENERATED>
  codefreshAgentName: "defaultAgent"
  codefreshURL: "https://g.codefresh.io"
  #codefreshKubeNamespace: "default"
