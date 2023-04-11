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

### Core Components

- [calico](https://github.com/projectcalico/calico): Internal Kubernetes networking plugin.
- [cert-manager](https://cert-manager.io/docs/): Creates SSL certificates for services in my Kubernetes cluster.
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx/): Ingress controller to expose HTTP traffic to pods over DNS.
- [longhorn](https://longhorn.io/docs/): Distributed block storage for persistent volumes.
- [sops](https://toolkit.fluxcd.io/guides/mozilla-sops/): Managed secrets for Kubernetes, Ansible and Terraform which are commited to Git.
- [volsync](https://github.com/backube/volsync) and [snapscheduler](https://github.com/backube/snapscheduler): Backup and recovery of persistent volume claims.
