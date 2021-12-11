FROM vault:1.9.0
ARG KUBECTL_VERSION="stable"

# Add more dependencies
RUN apk add  --no-cache jq bash curl openssl \
    && [[ $KUBECTL_VERSION = "stable" ]] && KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
    && curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

USER vault
CMD bash
