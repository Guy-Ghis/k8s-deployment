#!/bin/bash

# MkDocs Kubernetes Deployment Script
# This script deploys MkDocs with all required components

set -e  # Exit on any error

echo "🚀 Deploying MkDocs to Kubernetes..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_error "kubectl is not installed or not in PATH"
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster"
    exit 1
fi

print_status "Connected to Kubernetes cluster"

# Create namespace if it doesn't exist
NAMESPACE="mkdocs"
if ! kubectl get namespace $NAMESPACE &> /dev/null; then
    print_status "Creating namespace: $NAMESPACE"
    kubectl create namespace $NAMESPACE
else
    print_status "Namespace $NAMESPACE already exists"
fi

# Deploy ConfigMap
print_status "Deploying ConfigMap..."
kubectl apply -f k8s/mkdocs-configmap.yaml -n $NAMESPACE

# Deploy Secret
print_status "Deploying Secret..."
kubectl apply -f k8s/mkdocs-secret.yaml -n $NAMESPACE

# Deploy Deployment
print_status "Deploying Application..."
kubectl apply -f k8s/mkdocs-deployment.yaml -n $NAMESPACE

# Deploy Service
print_status "Deploying Service..."
kubectl apply -f k8s/mkdocs-service.yaml -n $NAMESPACE

# Deploy Ingress (optional)
if [ -f "k8s/mkdocs-ingress.yaml" ]; then
    print_status "Deploying Ingress..."
    kubectl apply -f k8s/mkdocs-ingress.yaml -n $NAMESPACE
fi

# Wait for deployment to be ready
print_status "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mkdocs -n $NAMESPACE

# Get deployment status
print_status "Deployment Status:"
kubectl get pods -l app=mkdocs -n $NAMESPACE

# Get service information
print_status "Service Information:"
kubectl get svc mkdocs -n $NAMESPACE

# Get ingress information (if exists)
if kubectl get ingress mkdocs-ingress -n $NAMESPACE &> /dev/null; then
    print_status "Ingress Information:"
    kubectl get ingress mkdocs-ingress -n $NAMESPACE
fi

# Display access information
echo ""
print_status "🎉 Deployment completed successfully!"
echo ""
print_status "Access your MkDocs application:"

# Get NodePort
NODEPORT=$(kubectl get svc mkdocs -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
if [ ! -z "$NODEPORT" ]; then
    echo "  - NodePort: http://localhost:$NODEPORT"
    echo "  - NodePort: http://<node-ip>:$NODEPORT"
fi

# Check if ingress exists
if kubectl get ingress mkdocs-ingress -n $NAMESPACE &> /dev/null; then
    HOST=$(kubectl get ingress mkdocs-ingress -n $NAMESPACE -o jsonpath='{.spec.rules[0].host}')
    echo "  - Ingress: http://$HOST"
    print_warning "Make sure to add '$HOST' to your /etc/hosts file for local testing"
    print_warning "Example: echo '127.0.0.1 $HOST' | sudo tee -a /etc/hosts"
fi

echo ""
print_status "To view logs:"
echo "  kubectl logs -l app=mkdocs -n $NAMESPACE"
echo ""
print_status "To delete deployment:"
echo "  kubectl delete namespace $NAMESPACE"