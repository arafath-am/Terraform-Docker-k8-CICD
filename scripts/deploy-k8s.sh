#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f k8s/
kubectl get pods -n campuscart

echo "If using Minikube, run: minikube service campuscart-app-service -n campuscart"
