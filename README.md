# MkDocs Project Documentation

A modern, containerized documentation site built with MkDocs Material theme, featuring Docker and Kubernetes deployment configurations for easy development and production deployment.

## 🚀 Features

- **MkDocs Material Theme**: Beautiful, responsive documentation with modern design
- **Docker Support**: Containerized development environment for consistent setup
- **Kubernetes Ready**: Production-ready K8s manifests for scalable deployment
- **Hot Reload**: Live preview during development with automatic reloading
- **Easy Deployment**: Multiple deployment options (local, Docker, Kubernetes)

## 📋 Prerequisites

Choose one of the following based on your preferred deployment method:

### For Local Development

- Python 3.7+
- pip package manager

### For Docker Development

- Docker Engine 20.x+
- Docker Compose 2.x+

### For Kubernetes Deployment

- Kubernetes cluster (local or cloud)
- kubectl configured to access your cluster
- Minikube (for local K8s testing)

## 🛠️ Installation & Setup

### Method 1: Local Development

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd my-mk-docs
   ```

2. **Install MkDocs and dependencies**

   ```bash
   pip install mkdocs-material
   ```

3. **Start the development server**

   ```bash
   mkdocs serve
   ```

4. **Access the documentation**
   - Open [http://localhost:8000](http://localhost:8000) in your browser

### Method 2: Docker Development (Recommended)

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd my-mk-docs
   ```

2. **Start with Docker Compose**

   ```bash
   docker-compose up -d
   ```

3. **Access the documentation**
   - Open [http://localhost:8000](http://localhost:8000) in your browser

4. **Stop the service**

   ```bash
   docker-compose down
   ```

### Method 3: Kubernetes Deployment

1. **Apply the Kubernetes manifests**

   ```bash
   kubectl apply -f k8s/mkdocs-deployment.yaml
   kubectl apply -f k8s/mkdocs-service.yaml
   ```

2. **Verify deployment**

   ```bash
   kubectl get pods -l app=mkdocs
   kubectl get services mkdocs
   ```

3. **Access the documentation**
   - For NodePort service: `http://<node-ip>:30080`
   - For Minikube: `minikube service mkdocs --url`

4. **Clean up deployment**

   ```bash
   kubectl delete -f k8s/
   ```

## 📁 Project Structure

```plaintext
my-mk-docs/
├── docs/                    # Documentation source files
│   └── index.md            # Homepage content
├── k8s/                    # Kubernetes manifests
│   ├── mkdocs-deployment.yaml
│   └── mkdocs-service.yaml
├── docker-compose.yml      # Docker Compose configuration
├── mkdocs.yml             # MkDocs configuration
├── .gitignore             # Git ignore rules
└── README.md              # This file
```

## ⚙️ Configuration

### MkDocs Configuration (`mkdocs.yml`)

The main configuration file controls:

- Site name and navigation structure
- Theme settings (Material theme)
- Plugin configurations
- Build settings

Key settings:

```yaml
site_name: My Project Docs
nav:
  - Home: index.md
theme:
  name: material
```

### Docker Configuration

The `docker-compose.yml` file provides:

- **Image**: `squidfunk/mkdocs-material` (official MkDocs Material image)
- **Port**: 8000 (mapped to host)
- **Volume**: Current directory mounted to `/docs` in container
- **Command**: `mkdocs serve --dev-addr=0.0.0.0:8000`

### Kubernetes Configuration

**Deployment** (`k8s/mkdocs-deployment.yaml`):

- Single replica deployment
- Uses the same MkDocs Material image
- Mounts documentation files via hostPath volume
- Exposes port 8000

**Service** (`k8s/mkdocs-service.yaml`):

- NodePort service type
- External access via port 30080
- Routes traffic to deployment pods

## 📝 Content Management

### Adding New Pages

1. **Create a new Markdown file** in the `docs/` directory:

   ```bash
   touch docs/new-page.md
   ```

2. **Add content** to your new file:

   ```markdown
   # New Page Title
   
   Your content here...
   ```

3. **Update navigation** in `mkdocs.yml`:

   ```yaml
   nav:
     - Home: index.md
     - New Page: new-page.md
   ```

### Organizing Content

- Use subdirectories in `docs/` for better organization
- Update the `nav` section in `mkdocs.yml` to reflect structure
- Use relative links between pages: `[Link text](../other-page.md)`

## 🔧 Development Workflow

### Live Editing

1. **Start the development server** (any method above)
2. **Edit files** in the `docs/` directory
3. **Changes are automatically reflected** in the browser
4. **No restart required** for content changes

### Building for Production

```bash
# Build static site
mkdocs build

# Serve built site locally
mkdocs serve --dev-addr=0.0.0.0:8000
```

The built site will be in the `site/` directory.

## 🐳 Docker Commands Reference

```bash
# Build and start services
docker-compose up -d

# View logs
docker-compose logs mkdocs

# Stop services
docker-compose down

# Rebuild and restart
docker-compose up -d --build

# Access container shell
docker-compose exec mkdocs sh
```

## ☸️ Kubernetes Commands Reference

```bash
# Deploy to cluster
kubectl apply -f k8s/

# Check deployment status
kubectl get deployments
kubectl get pods -l app=mkdocs
kubectl get services

# View logs
kubectl logs -l app=mkdocs

# Port forward for local access
kubectl port-forward service/mkdocs 8000:8000

# Scale deployment
kubectl scale deployment mkdocs --replicas=3

# Delete resources
kubectl delete -f k8s/
```

## 🔍 Troubleshooting

### Common Issues

- **Port already in use**

```bash
# Find and kill process using port 8000
lsof -ti:8000 | xargs kill -9
```

- **Docker permission errors**

```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

- **Kubernetes deployment not starting**

```bash
# Check pod status and logs
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

- **Volume mount issues in Kubernetes**

  - Ensure the hostPath in `mkdocs-deployment.yaml` points to the correct directory
  - Update the path to match your actual project location

## 📚 Additional Resources

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material Theme Documentation](https://squidfunk.github.io/mkdocs-material/)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test them
4. Commit your changes: `git commit -am 'Add some feature'`
5. Push to the branch: `git push origin feature-name`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Support

For issues and questions:

- Create an issue in the repository
- Check the troubleshooting section above
- Refer to the official documentation links
