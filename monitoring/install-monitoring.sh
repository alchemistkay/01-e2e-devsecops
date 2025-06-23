#!/bin/bash

set -e

# Namespace
NAMESPACE="monitoring"

# Create the namespace if it doesn't exist
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || \
  kubectl create namespace $NAMESPACE

# Add the Prometheus Community Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack
helm upgrade --install kube-prometheus \
  prometheus-community/kube-prometheus-stack \
  --namespace $NAMESPACE \
  --version 58.1.0 \
  --set grafana.enabled=true \
  --set grafana.service.type=LoadBalancer \
  --set grafana.adminPassword='admin' \
  --set prometheus.service.type=ClusterIP \
  --set alertmanager.enabled=false \
  --wait

# Wait for Grafana to be ready
echo "⏳ Waiting for Grafana to be ready..."
kubectl wait --namespace $NAMESPACE \
  --for=condition=Ready pod \
  -l app.kubernetes.io/name=grafana \
  --timeout=180s

# Get Grafana LoadBalancer URL
GRAFANA_URL=$(kubectl get svc kube-prometheus-grafana \
  -n $NAMESPACE \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "✅ Prometheus and Grafana installed successfully!"
echo "🌐 Access Grafana at: http://${GRAFANA_URL}"
echo "🔐 Default credentials — Username: admin, Password: admin"
