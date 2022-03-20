output "namespace" {
  value = kubernetes_namespace_v1.campuscart.metadata[0].name
}

output "app_service_name" {
  value = kubernetes_service_v1.app_service.metadata[0].name
}

output "node_port" {
  value = 30080
}

output "message" {
  value = "CampusCart deployed. Use kubectl get svc -n ${var.namespace} or minikube service campuscart-app-service -n ${var.namespace}."
}
