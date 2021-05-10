# CI/CD Pipeline

The Jenkins pipeline is stored in `jenkins/Jenkinsfile`.

## Pipeline Stages

1. **Checkout**
   - Pulls source code from GitHub.

2. **Build Java App**
   - Runs Maven package.
   - Produces a Spring Boot JAR file.

3. **Run Tests**
   - Runs unit tests using Maven.

4. **Build Docker Image**
   - Builds the Docker image from `backend/Dockerfile`.
   - Tags image using Jenkins build number and `latest`.

5. **Push Docker Image**
   - Logs in to Docker Hub.
   - Pushes both image tags.

6. **Deploy to Kubernetes**
   - Applies Kubernetes YAML files.
   - Updates the running deployment with the new image tag.
   - Waits for rollout status.

## Required Jenkins Setup

- Docker installed on Jenkins agent
- Maven installed on Jenkins agent, unless using a Maven-enabled agent image
- kubectl installed and configured
- Docker Hub credentials stored as `dockerhub-creds`

## Interview Explanation

The pipeline automates the delivery process. Every code push can trigger Jenkins to build the Java application, run tests, create a Docker image, push it to Docker Hub, and deploy it to Kubernetes. This reduces manual deployment mistakes and creates a repeatable release process.
