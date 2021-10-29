FROM docker-remote.artifactory.davita.com/vault:1.8.4
ARG KUBECTL_VERSION="stable"

# Add more dependencies
RUN apk add  --no-cache jq bash curl openssl \
    && curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

USER vault
CMD bash
