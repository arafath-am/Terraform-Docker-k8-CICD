variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "campuscart"
}

variable "app_image" {
  description = "Docker image for the Spring Boot application"
  type        = string
  default     = "your-dockerhub-username/campuscart:latest"
}

variable "mysql_root_password" {
  description = "MySQL root password"
  type        = string
  default     = "root123"
  sensitive   = true
}

variable "mysql_database" {
  description = "MySQL database name"
  type        = string
  default     = "campuscart"
}

variable "mysql_user" {
  description = "MySQL app username"
  type        = string
  default     = "campus"
}

variable "mysql_password" {
  description = "MySQL app password"
  type        = string
  default     = "campus123"
  sensitive   = true
}
