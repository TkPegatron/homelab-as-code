# Migrating database by hand

The command run in the containter in this instance holds the pod open after completing the initdb tasks, allowing us to import data from a local file using a pipe.

This is just the simplest way of doing it in the current without exsitsting backup infrastructure. (Also, what I am importing is a different database entirely)


```shell
# Apply kustomization from local terminal
kubectl apply --kustomize kubernetes/apps/default/netbox/app/bootstrap

# Import database stored on local machine
zcat kubernetes/apps/default/netbox/app/bootstrap/files/netbox-psql-backup-20230317.sql.gz \
  | kubectl exec -i deployments/netbox-initdb-adhoc -- /bin/bash -c \
  'PGPASSWORD="${POSTGRES_SUPER_PASS}" psql --host postgres-rw.default.svc.cluster.local --user postgres netbox'

# Cleanup resources
kubectl delete --kustomize kubernetes/apps/default/netbox/app/bootstrap
```
