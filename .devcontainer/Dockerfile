FROM docker.io/library/alpine:edge

ARG UPGRADE_PACKAGES="true"

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG TZ=America/Detroit

# Add package repositories 
RUN /bin/true \
    && echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories 

# System Packages
RUN apk add  --no-cache --upgrade \
    zsh bat direnv curl exa stow file git skim neovim starship tzdata \
    ca-certificates gpg gpg-agent openssh-client libcrypto3 \
    python3 py3-pip sshpass pcre

# Environment tools (For Terraform, Kubernetes & Ansible GitOps workflow)
RUN apk add --no-cache --upgrade \
    kubectl helm ansible terraform age pre-commit jq yq \ 
    yamllint ansible-lint ipcalc go-task

## Install Mozilla SOPS
RUN wget --output-document="/tmp/sops" "https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux.amd64" \
    && chmod +x /tmp/sops && mv /tmp/sops /usr/local/bin/sops

## Install (kubernetes-sigs) kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

## Install fluxcd
RUN curl -s "https://fluxcd.io/install.sh" | bash

# System Configuration
RUN \
    # Set the container's timezone \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    # Add local user account inside container \
    adduser --shell /bin/zsh --disabled-password $USERNAME
