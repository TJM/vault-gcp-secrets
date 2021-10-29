# Vault GCR Secrets

Use vault agent to keep a `vault_gcp_secret_roleset` service account key updated as a
docker-registry secret in Kubernetes. This can be used as `imagePullSecrets` to retrieve images
from a private GCR.

NOTE: This is alpha quality, use it at your own risk.
