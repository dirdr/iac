# iac

k3s GitOps cluster managed by ArgoCD. Add a file to `apps/` to deploy a new service.

## Bootstrap

```bash
chmod +x bootstrap/bootstrap.sh && ./bootstrap/bootstrap.sh
```

If repo is private, after bootstrap:
```bash
argocd repo add git@github.com:dirdr/iac.git --ssh-private-key-path ~/.ssh/id_ed25519
```

## ArgoCD

https://argocd.adrienpelfresne.com

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```
