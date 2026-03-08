#!/usr/bin/env bash
set -euo pipefail

ARGOCD_NAMESPACE="argocd"
ARGOCD_CHART_VERSION="9.4.7"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for cmd in kubectl helm; do
  command -v "$cmd" &>/dev/null || { echo "ERROR: $cmd not found"; exit 1; }
done

kubectl cluster-info --request-timeout=5s >/dev/null

kubectl create namespace "$ARGOCD_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade --install argocd argo/argo-cd \
  --namespace "$ARGOCD_NAMESPACE" \
  --version "$ARGOCD_CHART_VERSION" \
  --values "$SCRIPT_DIR/../helm/argocd/values.yaml" \
  --wait \
  --timeout 5m

kubectl apply -f "$SCRIPT_DIR/root-app.yaml"

echo "ArgoCD: https://argocd.adrienpelfresne.com"
echo "Password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)"
echo "If repo is private: argocd repo add git@github.com:dirdr/iac.git --ssh-private-key-path ~/.ssh/id_ed25519"
