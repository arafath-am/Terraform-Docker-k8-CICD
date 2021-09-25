#!/usr/bin/env bash
set -euo pipefail

IMAGE=${1:-your-dockerhub-username/campuscart:latest}

cd terraform
terraform init
terraform apply -var="app_image=$IMAGE"
