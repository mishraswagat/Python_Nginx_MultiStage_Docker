#!/bin/bash

CONTAINER_NAME=python-nginx
IMAGE_NAME=python-nginx-app

echo "Stopping and removing container if it exists..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo "Removing old image if it exists..."
docker rmi -f $IMAGE_NAME 2>/dev/null || true

docker build -t $IMAGE_NAME .

echo "Starting new container..."
docker run --log-driver=awslogs --log-opt awslogs-group=nginx-logs --log-opt awslogs-region=us-east-1 -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME

echo "Done. Container '$CONTAINER_NAME' is running."

