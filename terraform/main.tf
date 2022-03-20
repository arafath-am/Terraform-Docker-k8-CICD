provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace_v1" "campuscart" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret_v1" "campuscart_secret" {
  metadata {
    name      = "campuscart-secret"
    namespace = kubernetes_namespace_v1.campuscart.metadata[0].name
  }

  data = {
    MYSQL_ROOT_PASSWORD = var.mysql_root_password
    MYSQL_DATABASE      = var.mysql_database
    MYSQL_USER          = var.mysql_user
    MYSQL_PASSWORD      = var.mysql_password
    DB_USER             = var.mysql_user
    DB_PASSWORD         = var.mysql_password
  }

  type = "Opaque"
}

resource "kubernetes_config_map_v1" "campuscart_config" {
  metadata {
    name      = "campuscart-config"
    namespace = kubernetes_namespace_v1.campuscart.metadata[0].name
  }

  data = {
    DB_HOST = "mysql-service"
    DB_PORT = "3306"
    DB_NAME = var.mysql_database
  }
}

resource "kubernetes_persistent_volume_claim_v1" "mysql_pvc" {
  metadata {
    name      = "mysql-pvc"
    namespace = kubernetes_namespace_v1.campuscart.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace_v1.campuscart.metadata[0].name
    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:8.0"

          port {
            container_port = 3306
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.campuscart_secret.metadata[0].name
                key  = "MYSQL_ROOT_PASSWORD"
              }
            }
          }

          env {
            name = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.campuscart_secret.metadata[0].name
                key  = "MYSQL_DATABASE"
              }
            }
          }

          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.campuscart_secret.metadata[0].name
                key  = "MYSQL_USER"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.campuscart_secret.metadata[0].name
                key  = "MYSQL_PASSWORD"
              }
            }
          }

          volume_mount {
            name       = "mysql-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mysql-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.mysql_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "mysql_service" {
  metadata {
    name      = "mysql-service"
    namespace = kubernetes_namespace_v1.campuscart.metadata[0].name
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = "campuscart-app"
    namespace = kubernetes_namespace_v1.campuscart.metadata[0].name
    labels = {
      app = "campuscart-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "campuscart-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "campuscart-app"
        }
      }

      spec {
        container {
          name  = "campuscart-app"
          image = var.app_image

          port {
            container_port = 8080
          }

          env {
            name = "DB_HOST"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.campuscart_config.metadata[0].name
                key  = "DB_HOST"
              }
            }
          }

          env {
            name = "DB_PORT"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.campuscart_config.metadata[0].name
                key  = "DB_PORT"
              }
            }
          }

          env {
            name = "DB_NAME"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.campuscart_config.metadata[0].name
                key  = "DB_NAME"
              }
            }
          }

          env {
            name = "DB_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.campuscart_secret.metadata[0].name
                key  = "DB_USER"
              }
            }
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.campuscart_secret.metadata[0].name
                key  = "DB_PASSWORD"
              }
            }
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "768Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service_v1.mysql_service]
}

resource "kubernetes_service_v1" "app_service" {
  metadata {
    name      = "campuscart-app-service"
    namespace = kubernetes_namespace_v1.campuscart.metadata[0].name
  }

  spec {
    selector = {
      app = "campuscart-app"
    }

    port {
      port        = 80
      target_port = 8080
      node_port   = 30080
    }

    type = "NodePort"
  }
}
