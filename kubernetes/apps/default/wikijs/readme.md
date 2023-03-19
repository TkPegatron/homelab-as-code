This would be a fantastic DRY excersize

using a merge of some sort to build something that looks like this:

```yaml
initcontainers:
  init:
    env:
      DB_PASSWORD:
        valueFrom:
          secretKeyRef:
            name: *app
            key: DB_PASSWORD
      DB_USER: "wikijs"
      DB_URL:
        valueFrom:
          configMapKeyRef:
            name: *app
            key: DB_URL
env:
  DB_PASSWORD:
    valueFrom:
      secretKeyRef:
        name: *app
        key: DB_PASSWORD
  DB_USER: "wikijs"
  DB_URL:
    valueFrom:
      configMapKeyRef:
        name: *app
        key: DB_URL
```

but only specifying this in the merge and using some match rules

```yaml
DB_PASSWORD:
  valueFrom:
    secretKeyRef:
      name: *app
      key: DB_PASSWORD
DB_USER: "wikijs"
DB_URL:
  valueFrom:
    configMapKeyRef:
      name: *app
      key: DB_URL
```
