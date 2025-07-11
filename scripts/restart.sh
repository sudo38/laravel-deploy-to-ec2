#!/bin/bash
cd /var/www/laravel-app

echo "Stopping old container..."
docker stop laravel-app || true
docker rm laravel-app || true

echo "Starting new container..."
docker build -t laravel-app .
docker run -d --name laravel-app -p 80:8000 laravel-app