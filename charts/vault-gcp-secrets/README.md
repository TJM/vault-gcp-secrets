# Vault GCP Secrets

Use vault agent to keep a `vault_gcp_secrets_roleset` service account key updated as a
Kubernetes secret, either for docker-registry or generic (Opaque). This can be used
for various other pods needing access to Google Services without having a vault agent
for each one. It can also be used as `imagePullSecrets` (for docker type) to retrieve
images from a private GCR repository.

NOTE: We are using this code in the production environment. You may use it at your own risk.

| Value | Description | Default |
| ----- | ----------- | ------- |
| `image.repository` | The repository of the Docker image. | `ghcr.io/tjm/vault-gcp-secrets` |
| `image.tag` | The tag of the Docker image which should be used. | `v1.10.1` |
| `image.pullPolicy` | The pull policy for the Docker image, | `IfNotPresent` |
| `image.volumeMounts` | Mount additional volumns to the container. | `[]` |
| `imagePullSecrets` | Secrets which can be used to pull the Docker image. | `[]` |
| `nameOverride` | Expand the name of the chart. | `""` |
| `fullnameOverride` | Override the name of the app. | `""` |
| `environmentVars` | Pass environment variables from a secret to the containers. | `[]` |
| `vault.address` | The address where Vault listen on (e.g. `http://vault.example.com`). | `"http://vault:8200"` |
| `vault.authMethod` | The authentication method, which should be used by the operator. Can be `kubernetes` ([Kubernetes auth method](https://www.vaultproject.io/docs/auth/kubernetes.html)), or `approle` ([AppRole auth method](https://www.vaultproject.io/docs/auth/approle)). NOTE: `approle` requires `vault.credentialSecretName` and `kubernetes` requires `vault.kubernetesRole`  | `kubernetes` |
| `vault.authMountPath` | Authentication Mount Path in Vault (which defaults to auth/(authMethod)) | `null` |
| `vault.credentialSecretName` | Secret used for approle authentication, must be used for approle authMethod. Must have keys `role_id` and `secret_id`. | `null` |
| `vault.kubernetesRole` | The name of the role which is configured for the Kubernetes auth method. | `vault-gcp-secrets` |
| `rbac.create` | Create RBAC object, enable Role and Role binding creation. | `true` |
| `rbac.createrole` | Finetune RBAC, enable or disable Role creation. NOTE: ignored when `rbac.create` is not `true`. | `true` |
| `serviceAccount.create` | Create the service account. | `true` |
| `serviceAccount.name` | The name of the service account, which should be created/used by the operator. | `vault-gcp-secrets` |
| `podAnnotations` | Annotations for vault-gcp-secrets pod(s). | `{}` |
| `podSecurityContext`: | Security context policies to add to the operator pod. | `{}` |
| `securityContext`: | Security context policies to add to the containers. | `{}` |
| `podLabels` | Additional labels for the vault-gcp-secrets pod(s). | `{}` |
| `resources` | Set resources for the operator. (see values.yaml for example) | `{}` |
| `volumes` | Provide additional volumns for the container. | `[]` |
| `nodeSelector` | Set a node selector. | `{}` |
| `tolerations` | Set tolerations. | `[]` |
| `priorityClassName` | Optionally attach priority class to pod spec. | `null` |
| `replicaCount` | Number of replications which should be created (recommend leaving this as 1). | `1` |
| `deploymentStrategy` | Deployment strategy which should be used. | `{}` |
