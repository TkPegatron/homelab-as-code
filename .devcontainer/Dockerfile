ARG VARIANT=3.18
FROM docker.io/library/alpine:${VARIANT}

# -{ ENV: Consume Environment variables }
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG TZ=America/Detroit

# -{ MOD: Add repositories }
RUN /bin/true \
    && echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories

# -{ PMINST: Important system utilities }
RUN apk add --upgrade \
    util-linux pciutils usbutils coreutils binutils findutils grep iproute2

RUN apk add --upgrade \
    zsh bat direnv curl exa stow file git skim neovim starship tzdata \
    ca-certificates gpg gpg-agent openssh-client libcrypto3 \
    python3 py3-pip sshpass pcre

# Environment tools (For Terraform, Kubernetes & Ansible GitOps workflow)
RUN apk add --upgrade \
    kubectl kustomize helm ansible terraform age pre-commit jq yq \
    yamllint ansible-lint ipcalc go-task sops flux

# -{ MOD: Configure userspace environment }

RUN \
    # Set the container's timezone \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    # Add local user account inside container \
    adduser --shell /bin/zsh --disabled-password $USERNAME

USER $USERNAME

# Install Python Dependencies
COPY ./requirements.txt /opt/requirements.txt
RUN pip install -r /opt/requirements.txt

# Install Ansible Depenedencies
COPY ./requirements.yml /opt/requirements.yml
RUN ansible-galaxy install -r /opt/requirements.yml