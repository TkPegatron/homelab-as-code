## 📖 Overview

This is a mono repository for configuring and managing my home infrastructure and Kubernetes cluster.

## 🛡️ Firewall

Included in this repository is a set of playbooks and roles designed to configure a firewall running a RHEL derivative.

### Core Components

- Netfilter: The linux firewall, filters packets and performs NA[P]T.
- ISC Kea DHCP server: a modern, highly configurable dhcp server.
- KeepaliveD: VRRP Daemon.
- Fail2Ban

## ⛃ Network Storage

## ⛵ Kubernetes

My cluster is [k3s](https://k3s.io/) provisioned overtop bare-metal Fedora Server using the [Ansible](https://www.ansible.com/) galaxy role [ansible-role-k3s](https://github.com/PyratLabs/ansible-role-k3s). This is a semi hyper-converged cluster, workloads and block storage are sharing the same available resources on my nodes while I have a separate server for (NFS/S3) file storage.

A lot of this is based on the wonderful work of the k8s@home community.
They have a template: [onedr0p/flux-cluster-template](https://github.com/onedr0p/flux-cluster-template).

### Core Components

- [calico](https://github.com/projectcalico/calico): Internal Kubernetes networking plugin.
- [cert-manager](https://cert-manager.io/docs/): Creates SSL certificates for services in my Kubernetes cluster.
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx/): Ingress controller to expose HTTP traffic to pods over DNS.
- [longhorn](https://longhorn.io/docs/): Distributed block storage for persistent volumes.
- [sops](https://toolkit.fluxcd.io/guides/mozilla-sops/): Managed secrets for Kubernetes, Ansible and Terraform which are commited to Git.
- [volsync](https://github.com/backube/volsync) and [snapscheduler](https://github.com/backube/snapscheduler): Backup and recovery of persistent volume claims.
