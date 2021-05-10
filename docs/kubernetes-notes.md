# Kubernetes Notes

This project uses the following Kubernetes objects:

| Object | File | Purpose |
|---|---|---|
| Namespace | `00-namespace.yaml` | Groups all app resources |
| Secret | `01-secret.yaml` | Stores database passwords |
| ConfigMap | `02-configmap.yaml` | Stores non-sensitive configuration |
| PVC | `03-mysql-pvc.yaml` | Provides MySQL persistent storage |
| Deployment | `04-mysql-deployment.yaml` | Runs MySQL pod |
| Service | `05-mysql-service.yaml` | Internal MySQL network access |
| Deployment | `06-app-deployment.yaml` | Runs Spring Boot app pods |
| Service | `07-app-service.yaml` | Exposes app through NodePort |
| Ingress | `08-ingress.yaml` | Optional hostname-based routing |

## Useful Commands

```bash
kubectl get all -n campuscart
kubectl logs -n campuscart deployment/campuscart-app
kubectl describe pod -n campuscart <pod-name>
kubectl rollout restart deployment/campuscart-app -n campuscart
kubectl delete -f k8s/
```
