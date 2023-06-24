<div align="center">

<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="center" width="144px" height="144px"/>

</div>

## 📖 Overview

This is a mono repository for my home infrastructure and Kubernetes cluster based on the wonderful work of the k8s@home community.

Shout out to k8s@home, you can find the template this repo is mimicking here: [onedr0p/flux-cluster-template](https://github.com/onedr0p/flux-cluster-template)

## 🛡️ Firewall

Included in this repository is a set of playbooks designed to configure a firewall running Alma-Linux on a rasberry pi 4b.

### Core Components

- Netfilter: The linux firewall, filters packets and performs NA[P]T.
- Pihole: Internal DNS and adblocker

## ⛃ Network Storage

## ⛵ Kubernetes

My cluster is [k3s](https://k3s.io/) provisioned overtop bare-metal Fedora Server using the [Ansible](https://www.ansible.com/) galaxy role [ansible-role-k3s](https://github.com/PyratLabs/ansible-role-k3s). This is a semi hyper-converged cluster, workloads and block storage are sharing the same available resources on my nodes while I have a separate server for (NFS/S3) file storage.

🔸 _[Click here](./ansible/) to see my Ansible playbooks and roles._

### Core Components

- [actions-runner-controller](https://github.com/actions/actions-runner-controller): Self-hosted Github runners.
- [calico](https://github.com/projectcalico/calico): Internal Kubernetes networking plugin.
- [cert-manager](https://cert-manager.io/docs/): Creates SSL certificates for services in my Kubernetes cluster.
- [external-dns](https://github.com/kubernetes-sigs/external-dns): Automatically manages DNS records from my cluster in a cloud DNS provider.
- [external-secrets](https://github.com/external-secrets/external-secrets/): Managed Kubernetes secrets using [1Password Connect](https://github.com/1Password/connect).
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx/): Ingress controller to expose HTTP traffic to pods over DNS.
- [rook](https://github.com/rook/rook): Distributed block storage for peristent storage.
- [sops](https://toolkit.fluxcd.io/guides/mozilla-sops/): Managed secrets for Kubernetes, Ansible and Terraform which are commited to Git.
- [tf-controller](https://github.com/weaveworks/tf-controller): Additional Flux component used to run Terraform from within a Kubernetes cluster.
- [volsync](https://github.com/backube/volsync) and [snapscheduler](https://github.com/backube/snapscheduler): Backup and recovery of persistent volume claims.


























### GitOps

[Flux](https://github.com/fluxcd/flux2) watches my [kubernetes](./kubernetes/) folder (see Directories below) and makes the changes to my cluster based on the YAML manifests.

The way Flux works for me here is it will recursively search the [kubernetes/apps](./kubernetes/apps) folder until it finds the most top level `kustomization.yaml` per directory and then apply all the resources listed in it. That aforementioned `kustomization.yaml` will generally only have a namespace resource and one or many Flux kustomizations. Those Flux kustomizations will generally have a `HelmRelease` or other resources related to the application underneath it which will be applied.

[Renovate](https://github.com/renovatebot/renovate) watches my **entire** repository looking for dependency updates, when they are found a PR is automatically created. When some PRs are merged [Flux](https://github.com/fluxcd/flux2) applies the changes to my cluster.

### Directories

This Git repository contains the following directories under [kubernetes](./kubernetes/).

```sh
📁 kubernetes      # Kubernetes cluster defined as code
├─📁 bootstrap     # Flux installation
├─📁 flux          # Main Flux configuration of repository
└─📁 apps          # Apps deployed into my cluster grouped by namespace (see below)
```



---



This lab environment hosts a personal kubernetes cluster and self-engineered linux firewall.

The cluster is used to host a collection of personal cloud services such as a password manager, relational spreadsheet system, various media services, file-based synchronization, and centralized authentication.

My major goal with this repo is to learn both Linux system administration and engineering as well as kubernetes while also fostering infrastructure as code and ops skills.



### Vaultwarden

This command can be used to generate an admin token: `openssl rand -base64 48`






This pattern is interesting:

It uses the subpath feature to utilize a single volume, this simplifies managing the disk space allocated to a suit of containers.

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: &app netbox
  namespace: default
spec:
  values:
    persistence:
      data:
        enabled: true
        existingClaim: appdata
        subPath:
          - path: netbox/config
            mountPath: /etc/netbox
          - path: netbox/media
            mountPath: /opt/netbox/netbox/media
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: &app netbox-postgres
  namespace: default
spec:
  values:
    persistence:
      data:
        enabled: true
        mountPath: /var/lib/postgresql/data
        existingClaim: appdata
        subPath: netbox_db
```
