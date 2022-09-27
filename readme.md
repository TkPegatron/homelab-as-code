
  
<div align="center">

<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="center" width="144px" height="144px"/>

### My home operations repository :octocat:

</div>

**Note**: Project is preparing for a cluster rebuild and presentation for a group of savy friends.

This lab environment hosts a personal kubernetes cluster and self-engineered linux firewall.

The cluster is used to host a collection of personal cloud services such as a password manager, relational spreadsheet system, various media services, file-based synchronization, and centralized authentication.

My major goal with this repo is to learn both Linux system administration and engineering as well as kubernetes while also fostering infrastructure as code and ops skills.

More in-depth documentation, including drawio diagrams can be found in [./docs](./docs).

### Provisioning steps

cd provision/ansible
source ~/.local/lib/python-venv/ansible/bin/activate
ansible-playbook playbooks/k3s.deploy.yaml
helm template cilium cilium/cilium --namespace kube-system -f roles/k3s.kubernetes/templates/cilium/values.yaml > /tmp/cillium-manifest.yaml
kubectl apply -f /tmp/cilium-bgp-configmap.yaml
kubectl apply -f /tmp/cillium-manifest.yaml
export GITHUB_TOKEN=${github_token}
flux bootstrap github --owner=tkpegatron --repository=homelab-as-code --branch=main --path=./cluster/flux --personal
age-keygen -o age.agekey
cat age.agekey | kubectl create secret generic sops-age --namespace=flux-system --from-file=age.agekey=/dev/stdin

### TODO

- Ensure that requisite services are started and enabled regardless of configuration changes


- https://github.com/FiloSottile/age
