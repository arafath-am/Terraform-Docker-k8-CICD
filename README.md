# CampusCart DevOps Project

A college-level Java Spring Boot e-commerce-lite project focused on **Docker, Kubernetes, Terraform, and Jenkins CI/CD**.

CampusCart lets students browse used campus items, add items to a cart, and place a simple order. The app is intentionally small so the DevOps setup is easy to understand and explain in interviews.

## What this project demonstrates

- Java Spring Boot backend
- Simple frontend using HTML, CSS, and JavaScript
- MySQL database
- Docker containerization
- Docker Compose local environment
- Kubernetes deployment using YAML manifests
- Terraform provisioning using the Kubernetes provider
- Jenkins CI/CD pipeline

## Architecture

```text
Browser
  |
  v
Spring Boot App Container
  |
  v
MySQL Container / Pod
```

In Kubernetes:

```text
User -> NodePort/Ingress -> campuscart-app Service -> Spring Boot Pod -> mysql Service -> MySQL Pod + PVC
```

## Project Structure

```text
campuscart-devops/
├── backend/                  # Java Spring Boot app
├── docker-compose.yml         # Local Docker setup
├── k8s/                       # Kubernetes manifests
├── terraform/                 # Terraform Kubernetes provider setup
├── jenkins/                   # Jenkinsfile pipeline
├── scripts/                   # Helper scripts
├── docs/                      # Simple documentation
└── README.md
```

## Local Run with Docker Compose

Requirements:

- Docker
- Docker Compose

Run:

```bash
docker compose up --build
```

Open:

```text
http://localhost:8080
```

API health check:

```bash
curl http://localhost:8080/api/health
```

Stop:

```bash
docker compose down
```

Reset database:

```bash
docker compose down -v
```

## Run App Locally Without Docker

Requirements:

- Java 11+
- Maven

The default profile expects MySQL. For a simple local run using H2:

```bash
cd backend
mvn spring-boot:run -Dspring-boot.run.profiles=local-h2
```

Open:

```text
http://localhost:8080
```

## Docker Build Manually

```bash
cd backend
docker build -t campuscart:local .
docker run -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=3306 \
  -e DB_NAME=campuscart \
  -e DB_USER=campus \
  -e DB_PASSWORD=campus123 \
  campuscart:local
```

## Kubernetes Deployment

Use Minikube, Docker Desktop Kubernetes, or kind.

Apply manifests:

```bash
kubectl apply -f k8s/
```

Check pods:

```bash
kubectl get pods -n campuscart
```

Access the app using NodePort:

```bash
kubectl get svc -n campuscart campuscart-app-service
```

For Minikube:

```bash
minikube service campuscart-app-service -n campuscart
```

Delete everything:

```bash
kubectl delete -f k8s/
```

## Terraform Deployment

Terraform uses your current Kubernetes context from `~/.kube/config`.

```bash
cd terraform
terraform init
terraform plan -var="app_image=your-dockerhub-username/campuscart:latest"
terraform apply -var="app_image=your-dockerhub-username/campuscart:latest"
```

Destroy:

```bash
terraform destroy -var="app_image=your-dockerhub-username/campuscart:latest"
```

## Jenkins CI/CD Flow

The Jenkins pipeline does this:

```text
Checkout code from GitHub
  -> Build Java app
  -> Run tests
  -> Build Docker image
  -> Push image to Docker Hub
  -> Deploy to Kubernetes
```

Before using Jenkins:

1. Create a Docker Hub repository, for example:

```text
your-dockerhub-username/campuscart
```

2. In Jenkins, create a credential:

```text
Credential ID: dockerhub-creds
Type: Username with password
Username: your Docker Hub username
Password: your Docker Hub password or token
```

3. Make sure Jenkins has `docker`, `kubectl`, and access to your Kubernetes cluster.

4. Update this line in `jenkins/Jenkinsfile`:

```groovy
DOCKER_IMAGE = 'your-dockerhub-username/campuscart'
```

Then create a Jenkins Pipeline job pointing to this repository.

## Resume Bullet

```text
Built a Java Spring Boot student marketplace application and implemented DevOps automation using Docker, Kubernetes, Terraform, and Jenkins. Containerized the app with MySQL, deployed it to Kubernetes using Deployments, Services, ConfigMaps, Secrets, and PVCs, provisioned Kubernetes resources with Terraform, and created a Jenkins CI/CD pipeline to build, test, push Docker images, and deploy updates.
```

