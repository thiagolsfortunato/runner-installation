# Codefresh runner installation - helm chart

This helm chart will install Codefresh runner into your Kubernetes cluster. 
For additional information regarding "Codefresh Runner" look here: [https://codefresh.io/docs/docs/administration/codefresh-runner/](https://codefresh.io/docs/docs/administration/codefresh-runner/)


This helm chart support both Helm2 and Helm3.

## Prerequisite
1. If you are working on air-gapped environment (without internet access), make sure to push the image "codefresh/cli" into your local registry before proceeding with the installation, And set `installer.image` to your local repository.

2. Before you start to install this helm chart make sure you have a Codefresh API token, follow this doc for HOW-TO generate it: [https://codefresh.io/docs/docs/integrations/google-marketplace/#step-0---create-a-codefresh-api-key](https://codefresh.io/docs/docs/integrations/google-marketplace/#step-0---create-a-codefresh-api-key)

3. Clone this repo and pack the helm chart by executing:
```
git clone https://github.com/codefresh-io/runner-installation.git
```

## Installation
- Edit the file `values.yaml`. Reference [venonactl guide](https://github.com/codefresh-io/venona/tree/release-1.0/venonactl#install-using---values-valuesyaml)
  
- (Optional) If using k8s secrets for your token, create a secret using: `kubectl create secret generic codefresh-secrets --from-literal=token=<TOKEN_ID_YOU_GENERATED> -n <NAMESPACE>` or follow [steps from the kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/secret/#creating-a-secret) and specify codefreshTokenSecret 
```
codefreshTokenSecret:
  name: codefresh-secrets
  key: token
```

- Run helm installation: 
```
helm install --namespace <NAMESPACE> --timeout 1500s <RELEASE-NAME> .
```
It performs runner installation in <release-name>-installer pod labels `app=cf-installer`

## Upgrades and Administration
Exec into pod <release-name>-installer to perform any codefresh-cli administrative command
For example:
```
kubectl get pods -l app=cf-installer
NAME                        READY   STATUS    RESTARTS   AGE
cf-runner-installer-h5ebz   1/1     Running   0          9m9s
````

```
kubectl exec -it cf-runner-installer-h5ebz -- bash
```
or
```
kubectl exec -it $(kubectl get pod -l app=cf-installer -o name) -- bash
```

You can run, for example
```
codefresh runner upgrade --agent-name <CF_AGENT_NAME>
```

runner-values is mounted to `/etc/codefresh/runner-values.yaml`



## installer parameters in values.yaml
|                            |Description                                     |Default                 |
|----------------------------|------------------------------------------------|------------------------|
|installer.env               | env vars for installer - env.http_proxy , etc  | {}                     |
|installer.image             |"The codefresh-cli image path".                 |codefresh/cli           |
|installer.imagePullSecrets  |"list of kubernetes pull images secrets         | []  (empty list)       |
|installer.serviceAccount    |"serviceAccount options - create or use existing| create                 |

