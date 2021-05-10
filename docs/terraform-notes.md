# Terraform Notes

Terraform provisions the same type of Kubernetes resources as the YAML files, but using infrastructure as code.

## Why Terraform is included

Using Terraform shows that infrastructure can be version-controlled, reviewed, and recreated in a consistent way.

## Commands

```bash
cd terraform
terraform init
terraform plan
terraform apply
terraform destroy
```

To use your Docker image:

```bash
terraform apply -var="app_image=your-dockerhub-username/campuscart:latest"
```

## Important Note

This Terraform setup assumes your machine already has Kubernetes access through `~/.kube/config`. For example, Minikube, Docker Desktop Kubernetes, or kind.
