# CampusCart Architecture

CampusCart is a simple Java Spring Boot marketplace application for students. The project is designed to demonstrate DevOps skills more than application complexity.

## Components

| Component | Purpose |
|---|---|
| Spring Boot App | Product browsing, cart checkout, order APIs, static frontend |
| MySQL | Stores products and customer orders |
| Docker | Packages app and database consistently |
| Kubernetes | Runs app and database as pods with services and storage |
| Terraform | Provisions Kubernetes resources using infrastructure as code |
| Jenkins | Automates build, test, Docker image push, and deployment |

## Application Flow

```text
User opens browser
  -> Static frontend loads from Spring Boot
  -> Frontend calls /api/products
  -> User adds products to cart
  -> Frontend posts order to /api/orders
  -> Spring Boot stores order in MySQL
```

## Kubernetes Flow

```text
NodePort Service
  -> campuscart-app Deployment
  -> mysql-service
  -> mysql Deployment
  -> mysql-pvc persistent storage
```

## Why this is a good student project

The app is small but it uses real deployment patterns: environment variables, secrets, config maps, persistent storage, image builds, and automated CI/CD.
