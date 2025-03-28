# Wisecow Application Deployment on Kubernetes

This repository contains the process for containerizing and deploying the **Wisecow application** using **Docker**, **Kubernetes**, and **Helm**. It includes Dockerization, Kubernetes deployment configurations, CI/CD integration with GitHub Actions, and TLS communication for secure access.

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Dockerization](#dockerization)
  - [Build Docker Image](#build-docker-image)
  - [Run Docker Container](#run-docker-container)
- [Kubernetes Deployment](#kubernetes-deployment)
  - [Create Deployment YAML](#create-deployment-yaml)
  - [Create Service YAML](#create-service-yaml)
  - [Create Ingress YAML](#create-ingress-yaml)
- [CI/CD Integration with GitHub Actions](#cicd-integration-with-github-actions)
- [TLS Implementation](#tls-implementation)
- [Conclusion](#conclusion)

---

## Overview

The **Wisecow** application is a simple script that generates a fortune and displays it with a cow. The project involves:

- **Dockerizing** the application for containerization.
- Deploying the application on **Kubernetes** for scalability and reliability.
- Using **Helm** for managing Kubernetes deployments.
- Implementing **CI/CD** using **GitHub Actions** for continuous build and deployment.
- Securing the application using **TLS** with Kubernetes Ingress.

---

## Prerequisites

To get started with this project, you need to have the following tools installed on your local machine:

- [Docker](https://www.docker.com/get-started) for containerizing the application.
- [Kubernetes](https://kubernetes.io/docs/setup/) for orchestrating the application.
- [Helm](https://helm.sh/docs/intro/install/) for managing Kubernetes charts.
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for interacting with Kubernetes.
- A GitHub account and a repository for CI/CD with GitHub Actions.
- A domain with TLS certificate (for securing Ingress traffic).

---

## Dockerization

### Step 1: Clone the Repository

Clone the Wisecow repository from GitHub:

```bash
git clone https://github.com/nyrahul/wisecow.git
cd wisecow

## Step 2: Create Dockerfile

The `Dockerfile` defines the instructions to build a Docker image for the Wisecow application. Below is the content of the `Dockerfile`:

```dockerfile
FROM ubuntu:latest

# Set environment variables
ENV SRVPORT=4499
ENV PATH="/usr/games:${PATH}"

# Install dependencies
RUN apt-get update && apt-get install -y \
    fortune-mod cowsay netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy the script into the container
COPY wisecow.sh /wisecow.sh

# Give execution permissions
RUN chmod +x /wisecow.sh

# Expose the server port
EXPOSE 4499

# Run the script
CMD ["/wisecow.sh"]
```

## Building the Docker Image

To build the Docker image, run the following command:

```bash
docker build -t wisecow .
```

To RUN the Docker image, run the following command:
```bash
docker run -d -p 4499:4499 wisecow:latest
```
## Kubernetes Deployment

1. **Create Deployment YAML (`deploy.yaml`)**:
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: wisecow-deployment
      labels:
        app: wisecow
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: wisecow
      template:
        metadata:
          labels:
            app: wisecow
        spec:
          containers:
            - name: wisecow
              image: pav30/wisecow:latest  # Replace with your Docker Hub image
              ports:
                - containerPort: 4499  # Changed port to 4499

   ```
2. **Create Service YAML (`service.yaml`)**:
  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: wisecow-service
  spec:
    selector:
      app: wisecow
    ports:
      - protocol: TCP
        port: 80
        targetPort: 4499
        nodePort: 30000
    type: NodePort
   ```

      
2. **Create Ingress YAML (`ingress.yaml`)**:
   
```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: wisecow-ingress
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
  spec:
    ingressClassName: nginx
    tls:
      - hosts:
          - wisecow.example.com
        secretName: wisecow-tls  # 🔹 Use the TLS secret you created
    rules:
      - host: wisecow.example.com
        http:
          paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: wisecow-service
                  port:
                    number: 80
```

# Wisecow Helm Chart

This Helm chart simplifies the deployment and packaging of the **Wisecow** application on Kubernetes. It includes necessary Kubernetes resources like Deployment, Service, and Ingress to get your application running quickly.


## Continuous Integration and Deployment (CI/CD)

1. **GitHub Actions Workflow**:
   - Create `.github/workflows/ci-cd.yml`:
     ```yaml
     name: CI/CD Pipeline

      on:
        push:
          branches:
            - main
      
      jobs:
        build-and-deploy:
          runs-on: ubuntu-latest
          steps:
      
          - name: Checkout code
            uses: actions/checkout@v2
      
          - name: Set up Docker Buildx
            uses: docker/setup-buildx-action@v1
      
          - name: Login to Container Registry
            uses: docker/login-action@v1
            with:
              username: ${{ secrets.REGISTRY_USERNAME }}
              password: ${{ secrets.REGISTRY_PASSWORD }}
      
          - name: Build Docker image
            run: docker buildx build -t pav30/wisecow-app:${{ github.run_id }} --push .
      
          - name: Update tag in Helm
            run: |
              sed -i 's/tag: .*/tag: "${{ github.run_id }}"/' wisecow-chart/values.yaml

  
     ```
   - Configure Docker and Kubernetes secrets in the GitHub repository settings.

  ## TLS Implementation

1. **Generate TLS Certificates**:
   - Use OpenSSL to generate self-signed TLS certificates:

   ```bash
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
   -keyout tls.key -out tls.crt -subj "/CN=wisecow.example.com/O=wisecow"
   ```

## Create TLS Secret in Kubernetes:

2.  **Create a secret in Kubernetes to store the generated certificates**:

```bash
kubectl create secret tls wisecow-tls --cert=tls.crt --key=tls.key
 ```
## Improvements
# Continuous Deployment with Argo CD:

You can integrate Argo CD to automate the continuous deployment process, making it easier to manage your Kubernetes applications and sync deployments with your Git repository.

# Using Certbot for TLS Certificates:

Instead of manually generating self-signed certificates, you can use Certbot to automatically obtain and renew trusted certificates from Let's Encrypt for better security and convenience.

# Using a Load Balancer for IP Access:

To improve accessibility and distribute traffic efficiently, consider using a Load Balancer in your Kubernetes cluster. This ensures high availability and provides a stable public IP for your application.
