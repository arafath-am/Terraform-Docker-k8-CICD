#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=${1:-campuscart:local}

docker build -t "$IMAGE_NAME" backend

echo "Built Docker image: $IMAGE_NAME"
