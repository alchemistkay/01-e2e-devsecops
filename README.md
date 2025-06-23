# From Code to Kubernetes: A Zero-Compromise DevSecOps Pipeline for MERN Apps

This repository contains the **Infrastructure-as-Code (IaC)** components of a complete, production-ready DevSecOps pipeline for deploying a MERN (MongoDB, Express, React, Node.js) application on **Amazon EKS**. It uses **Terraform** to provision cloud infrastructure and integrates with **Jenkins**, **ArgoCD**, **ECR**, and various AWS services to support a robust and secure CI/CD workflow.

---

## 📌 Project Overview

- ✅ Provisioning of VPC, EKS, ECR, IAM, and supporting components
- ✅ Secure image scanning and pull permissions (IRSA + ECR)
- ✅ GitOps with ArgoCD for declarative Kubernetes deployment
- ✅ Ingress via AWS Load Balancer Controller
- ✅ Persistent storage via Amazon EBS CSI Driver
- ✅ Monitoring-ready setup with Prometheus and Grafana

---

##  📦 CI/CD Pipeline Flow (Jenkins + ArgoCD)

- Jenkins builds and scans Docker images

- Pushes to ECR and commits Helm manifests to Git

- ArgoCD watches the Git repo and deploys changes to EKS

- AWS Load Balancer Controller provides external access via HTTPS

- EBS CSI Driver provides storage for MongoDB or volumes

- Monitoring-ready setup for Prometheus & Grafana

---

## 🔒 Security Features

- ECR Access via IAM Roles for Service Accounts (IRSA)

- Immutable Docker tags

- Least-privilege IAM policies

- Pod Identity Agent support

- GitOps ensures auditability and rollback

---

## 📁 Project Structure

```
.
├── app                          # MERN application source code
│   ├── client                   # React frontend
│   │   ├── Dockerfile.dev       # Dev build for React
│   │   ├── Dockerfile.prod      # Prod build with Nginx
│   │   ├── nginx.conf           # Nginx configuration for frontend
│   │   ├── package.json         # Frontend dependencies and scripts
│   │   ├── public               # Static files (favicon, index.html, etc.)
│   │   └── src                  # React components, pages, context
│   ├── server                   # Node.js/Express backend
│   │   ├── Dockerfile.dev       # Dev Dockerfile
│   │   ├── Dockerfile.prod      # Production Dockerfile
│   │   ├── package.json         # Backend dependencies
│   │   ├── config               # DB and environment configuration
│   │   ├── controllers          # Express controllers
│   │   ├── models               # Mongoose models
│   │   ├── routes               # API routes
│   │   └── server.js            # App entry point
│   ├── docker-compose.dev.yml  # Dev environment setup
│   ├── docker-compose.prod.yaml# Production environment setup
│   └── Jenkinsfile             # CI/CD pipeline for app
│
├── infra-tf                     # Terraform Infrastructure as Code
│   ├── backend.tf               # Remote state configuration
│   ├── main.tf                  # Root module calling submodules
│   ├── prod.tfvars              # Production environment variables
│   ├── variables.tf             # Input variables for Terraform
│   ├── outputs.tf               # Output values for reuse
│   ├── workflows
│   │   └── Jenkinsfile          # Jenkins pipeline for Terraform infrastructure
│   └── modules                  # Terraform module definitions
│       ├── vpc                  # VPC networking resources
│       ├── eks                  # Amazon EKS cluster setup
│       ├── ecr                  # ECR repository roles and policies
│       ├── ecr-access           # IRSA + ECR access policies
│       ├── ecr-repos            # ECR repositories for backend/frontend
│       ├── argocd               # ArgoCD GitOps deployment
│       ├── aws-lbc              # AWS Load Balancer Controller
│       ├── ebs-csi-driver       # EBS volume CSI driver setup
│       ├── pod-identity         # Pod identity for IAM roles
│
├── k8s-manifests                # Kubernetes YAML manifests
│   ├── frontend                 # Frontend Deployment & Service
│   ├── backend                  # Backend Deployment & Service
│   ├── database                 # MongoDB StatefulSet, Service, PVC
│   └── ingress.yaml             # Ingress routing for app access
│
├── monitoring                   # Monitoring stack setup
│   └── install-monitoring.sh    # Script to install Prometheus & Grafana via Helm
│
└── README.md                    # Project documentation

```

---

