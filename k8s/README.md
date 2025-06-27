# MkDocs Kubernetes Deployment

This directory contains all the Kubernetes manifests needed to deploy MkDocs with the required components.

## Components Included

### ✅ Required Components (All Present)

1. **Deployment** (`mkdocs-deployment.yaml`)
   - Runs 2 replicas for high availability
   - Uses Material theme image
   - Includes health checks and resource limits
   - Mounts ConfigMap and Secret

2. **ConfigMap** (`mkdocs-configmap.yaml`)
   - Stores MkDocs configuration
   - Environment variables
   - Theme settings

3. **Secret** (`mkdocs-secret.yaml`)
   - Stores sensitive data (session secrets, API keys)
   - Base64 encoded values

4. **Service** (`mkdocs-service.yaml`)
   - NodePort service for local access
   - Exposes port 8000 on NodePort 30080

### Additional Components

5. **Ingress** (`mkdocs-ingress.yaml`)
   - HTTP/HTTPS access with custom domain
   - NGINX ingress controller annotations

6. **LoadBalancer Service** (`mkdocs-service-loadbalancer.yaml`)
   - Alternative service for cloud environments
   - Gets external IP automatically

## Quick Deployment

### Option 1: Use the deployment script (Recommended)

```bash
./deploy.sh
```

### Option 2: Manual deployment

```bash
# Create namespace
kubectl create namespace mkdocs

# Deploy all components
kubectl apply -f k8s/ -n mkdocs

# Wait for deployment
kubectl wait --for=condition=available --timeout=300s deployment/mkdocs -n mkdocs
```

## Access Methods

### 1. NodePort (Default)

```bash
# Access via NodePort
http://localhost:30080
# Or if running on remote cluster
http://<node-ip>:30080
```

### 2. Port Forward (Development)

```bash
kubectl port-forward svc/mkdocs 8000:8000 -n mkdocs
# Then access: http://localhost:8000
```

### 3. Ingress (Production)

```bash
# Add to /etc/hosts (for local testing)
echo "127.0.0.1 mkdocs.local" | sudo tee -a /etc/hosts

# Access via browser
http://mkdocs.local
```

### 4. LoadBalancer (Cloud)

```bash
# Deploy LoadBalancer service
kubectl apply -f k8s/mkdocs-service-loadbalancer.yaml -n mkdocs

# Get external IP
kubectl get svc mkdocs-lb -n mkdocs
# Access via the EXTERNAL-IP shown
```

## Configuration

### Updating ConfigMap

```bash
# Edit the configmap
kubectl edit configmap mkdocs-config -n mkdocs

# Or update from file
kubectl apply -f k8s/mkdocs-configmap.yaml -n mkdocs

# Restart deployment to pick up changes
kubectl rollout restart deployment/mkdocs -n mkdocs
```

### Updating Secrets

```bash
# Encode new values
echo -n "new-secret-value" | base64

# Edit the secret
kubectl edit secret mkdocs-secret -n mkdocs

# Or update from file
kubectl apply -f k8s/mkdocs-secret.yaml -n mkdocs

# Restart deployment
kubectl rollout restart deployment/mkdocs -n mkdocs
```

## Monitoring and Troubleshooting

### Check deployment status

```bash
kubectl get pods -l app=mkdocs -n mkdocs
kubectl get svc -n mkdocs
kubectl get ingress -n mkdocs
```

### View logs

```bash
# All pods
kubectl logs -l app=mkdocs -n mkdocs

# Specific pod
kubectl logs <pod-name> -n mkdocs

# Follow logs
kubectl logs -f -l app=mkdocs -n mkdocs
```

### Debug pod issues

```bash
# Describe pod
kubectl describe pod <pod-name> -n mkdocs

# Execute into pod
kubectl exec -it <pod-name> -n mkdocs -- /bin/sh

# Check events
kubectl get events -n mkdocs --sort-by='.lastTimestamp'
```

### Scale deployment

```bash
# Scale up/down
kubectl scale deployment mkdocs --replicas=3 -n mkdocs
```

## Security Notes

1. **Change default secrets** in `mkdocs-secret.yaml`
2. **Use proper RBAC** for production deployments
3. **Enable TLS** in ingress for HTTPS
4. **Scan images** for vulnerabilities
5. **Limit resource usage** appropriately

## Cleanup

```bash
# Delete everything
kubectl delete namespace mkdocs

# Or delete individual components
kubectl delete -f k8s/ -n mkdocs
```

## File Structure

```plaintext
k8s/
├── mkdocs-deployment.yaml       # Main application deployment
├── mkdocs-service.yaml          # NodePort service
├── mkdocs-service-loadbalancer.yaml  # LoadBalancer service (optional)
├── mkdocs-configmap.yaml        # Configuration data
├── mkdocs-secret.yaml           # Sensitive data
├── mkdocs-ingress.yaml          # HTTP/HTTPS routing
└── README.md                    # This file
```

## Requirements Met ✅

- [x] **Deployment**: `mkdocs-deployment.yaml`
- [x] **ConfigMap**: `mkdocs-configmap.yaml`
- [x] **Secret**: `mkdocs-secret.yaml`
- [x] **Service**: `mkdocs-service.yaml`
- [x] **Browser Accessible**: Multiple access methods (NodePort, Ingress, LoadBalancer)
