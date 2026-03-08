# iac

k3s GitOps cluster managed by ArgoCD. Add a file to `apps/` to deploy a new service.

## Bootstrap

```bash
chmod +x bootstrap/bootstrap.sh && ./bootstrap/bootstrap.sh
```

repo is private: after bootstrap (assuming id_ed25519 basic name)
```bash
argocd repo add git@github.com:dirdr/iac.git --ssh-private-key-path ~/.ssh/id_ed25519
```

## Adding a new app

1. Add `helm/<app-name>/values.yaml` with your Helm values
2. Add `apps/<app-name>.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: <app-name>
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.io
spec:
  project: default
  sources:
    - repoURL: <helm-chart-repo-url>
      chart: <chart-name>
      targetRevision: <version>
      helm:
        valueFiles:
          - $values/helm/<app-name>/values.yaml
    - repoURL: git@github.com:dirdr/iac.git
      targetRevision: HEAD
      ref: values
  destination:
    server: https://kubernetes.default.svc
    namespace: <app-namespace>
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

3. Push — ArgoCD deploys automatically.

## ArgoCD

https://argocd.adrienpelfresne.com

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```
