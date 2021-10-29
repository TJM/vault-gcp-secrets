# Vault GCR Secrets

Use vault agent to keep a `vault_gcp_secret_roleset` service account key updated as a
docker-registry secret in Kubernetes. This can be used as `imagePullSecrets` to retrieve images
from a private GCR.

NOTE: This is alpha quality, use it at your own risk.

| Value | Description | Default |
| ----- | ----------- | ------- |
| `replicaCount` | Number of replications which should be created. | `1` |
| `deploymentStrategy` | Deployment strategy which should be used. | `{}` |
| `image.repository` | The repository of the Docker image. | `tjm/vault-gcr-secrets` |
| `image.tag` | The tag of the Docker image which should be used. | `1.15.2` |
| `image.pullPolicy` | The pull policy for the Docker image, | `IfNotPresent` |
| `image.volumeMounts` | Mount additional volumns to the container. | `[]` |
| `imagePullSecrets` | Secrets which can be used to pull the Docker image. | `[]` |
| `nameOverride` | Expand the name of the chart. | `""` |
| `fullnameOverride` | Override the name of the app. | `""` |
| `environmentVars` | Pass environment variables from a secret to the containers. This must be used if you use the Token auth method of Vault. | `[]` |
| `vault.address` | The address where Vault listen on (e.g. `http://vault.example.com`). | `"http://vault:8200"` |
| `vault.authMethod` | The authentication method, which should be used by the operator. Can by `token` ([Token auth method](https://www.vaultproject.io/docs/auth/token.html)), `kubernetes` ([Kubernetes auth method](https://www.vaultproject.io/docs/auth/kubernetes.html)), or `approle` ([AppRole auth method](https://www.vaultproject.io/docs/auth/approle)). | `token` |
| `vault.tokenPath` | Path to file with the Vault token if the used auth method is `token`. Can be used to read the token from a file and not from the  `VAULT_TOKEN` environment variable. | `""` |
| `vault.kubernetesPath` | If the Kubernetes auth method is used, this is the path where the Kubernetes auth method is enabled. | `auth/kubernetes` |
| `vault.kubernetesRole` | The name of the role which is configured for the Kubernetes auth method. | `vault-gcr-secrets` |
| `vault.appRolePath` | If the AppRole auth method is used, this is the path where the AppRole auth method is enabled. | `auth/approle` |
| `vault.reconciliationTime` | The time after which the reconcile function for the CR is rerun. If the value is 0, automatic reconciliation is skipped. | `0` |
| `rbac.create` | Create RBAC object, enable Role and Role binding creation. | `true` |
| `rbac.createrole` | Finetune RBAC, enable or disable Role creation. NOTE: ignored when `rbac.create` is not `true`. | `true` |
| `serviceAccount.create` | Create the service account. | `true` |
| `serviceAccount.name` | The name of the service account, which should be created/used by the operator. | `vault-gcr-secrets` |
| `podAnnotations` | Annotations for vault-gcr-secrets pod(s). | `{}` |
| `podSecurityContext`: | Security context policies to add to the operator pod. | `{}` |
| `securityContext`: | Security context policies to add to the containers. | `{}` |
| `podLabels` | Additional labels for the vault-gcr-secrets pod(s). | `{}` |
| `testPodAnnotations` | Annotations for vault-gcr-secrets-test-connection pod. | `{}` |
| `testPodLabels` | Additional labels for the vault-gcr-secrets-test-connection pod. | `{}` |
| `resources` | Set resources for the operator. | `{}` |
| `volumes` | Provide additional volumns for the container. | `[]` |
| `nodeSelector` | Set a node selector. | `{}` |
| `tolerations` | Set tolerations. | `[]` |
| `serviceMonitor.enabled` | Enable the creation of a ServiceMonitor for the Prometheus Operator. | `false` |
| `serviceMonitor.labels` | Additional labels which should be set for the ServiceMonitor. | `{}` |
| `serviceMonitor.interval` | Scrape interval. | `10s` |
| `serviceMonitor.scrapeTimeout` | Scrape timeout. | `10s` |
| `serviceMonitor.honorLabels` | Honor labels option. | `true` |
| `serviceMonitor.relabelings` | Additional relabeling config for the ServiceMonitor. | `[]` |
| `priorityClassName` | Optionally attach priority class to pod spec. | `null` |
