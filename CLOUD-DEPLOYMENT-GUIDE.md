# Keycloak Cloud Deployment Guide

## Overview
This guide covers deploying Keycloak to your cloud Kubernetes environment with proper HTTPS configuration.

## Prerequisites
- Kubernetes cluster with access to deploy workloads
- PostgreSQL database service running at `postgres-arm-prod-database-service.database:5432`
- Database `keycloak` created with user `quriousri_owner`
- Container registry access to push your Docker image

## Deployment Files

### 1. Production Dockerfile
- **File**: `Dockerfile`
- **Features**: 
  - Multi-stage build for optimized image size
  - Self-signed SSL certificate generation
  - Production-ready configuration
  - HTTPS on port 8443

### 2. Kubernetes Environment Configuration
- **File**: `k8s-cloud.yaml`
- **Contains**: All required environment variables for cloud deployment

### 3. Local Production Testing
- **File**: `docker-compose.yml`
- **Purpose**: Test production configuration locally before cloud deployment

## Environment Variables Configuration

The configuration is split between Dockerfile (static settings) and k8s-cloud.yaml (runtime settings).

### Variables Set in Dockerfile (No need to override in k8s):
- `KC_DB=postgres` - Database type
- `KC_HOSTNAME_STRICT=true` - Strict hostname checking
- `KC_HOSTNAME_STRICT_HTTPS=true` - HTTPS enforcement
- `KC_HTTP_ENABLED=false` - HTTP disabled
- `KC_HTTPS_KEY_STORE_FILE` & `KC_HTTPS_KEY_STORE_PASSWORD` - SSL certificate
- `KC_HEALTH_ENABLED=true` & `KC_METRICS_ENABLED=true` - Monitoring

### Variables Set in k8s-cloud.yaml (Runtime configuration):

#### Database Connection
```yaml
KC_DB_URL: jdbc:postgresql://postgres-arm-prod-database-service.database:5432/keycloak
KC_DB_USERNAME: quriousri_owner
KC_DB_PASSWORD: RnJBi9r4NILn5EndBLil
```

#### Admin User (Bootstrap)
```yaml
KC_BOOTSTRAP_ADMIN_USERNAME: admin
KC_BOOTSTRAP_ADMIN_PASSWORD: 707aAm8o13GXu9OswLpgTU
```

#### Hostname Configuration
```yaml
KC_HOSTNAME: keycloak.artixio.com
KC_HOSTNAME_URL: https://keycloak.artixio.com
KC_HOSTNAME_STRICT_BACKCHANNEL: "true"
```

#### Cloud Proxy Settings
```yaml
KC_PROXY: edge
PROXY_ADDRESS_FORWARDING: "true"
```

## Deployment Steps

### Step 1: Build and Push Docker Image
```bash
# Build the production image
docker build -t your-registry/keycloak-artixio:latest .

# Push to your container registry
docker push your-registry/keycloak-artixio:latest
```

### Step 2: Deploy to Kubernetes
```bash
# Apply your Kubernetes configuration
# (Replace with your actual Kubernetes deployment method)
kubectl apply -f your-keycloak-deployment.yaml
```

### Step 3: Verify Database Connection
Ensure your PostgreSQL service is accessible and the `keycloak` database exists:
```sql
-- Connect to your cloud PostgreSQL
-- Verify database exists
\l keycloak
-- Verify user permissions
\du quriousri_owner
```

### Step 4: Access Keycloak
- **URL**: https://keycloak.artixio.com
- **Admin Console**: https://keycloak.artixio.com/admin
- **Credentials**: admin / 707aAm8o13GXu9OswLpgTU

## Important Notes

### SSL Certificate
- Currently using self-signed certificate generated during build
- **For production**: Replace with proper SSL certificates from a CA
- Certificate is valid for: `keycloak.artixio.com`, `localhost`, `127.0.0.1`

### Security Considerations
1. **Change default passwords** in production
2. **Use proper SSL certificates** instead of self-signed
3. **Secure database credentials** using Kubernetes secrets
4. **Enable proper logging and monitoring**

### Performance Settings
- **Memory**: 64MB min, 1536MB max
- **Metaspace**: 96MB min, 256MB max
- **Database connection lifetime**: 20 hours

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Verify PostgreSQL service is running
   - Check database credentials
   - Ensure `keycloak` database exists

2. **SSL Certificate Issues**
   - Browser warnings are expected with self-signed certificates
   - For production, use proper CA-signed certificates

3. **Proxy Configuration**
   - Ensure load balancer properly forwards headers
   - `KC_PROXY=edge` handles X-Forwarded-* headers

### Health Checks
- **Health endpoint**: https://keycloak.artixio.com/health
- **Metrics endpoint**: https://keycloak.artixio.com/metrics
- **Ready endpoint**: https://keycloak.artixio.com/health/ready

## Monitoring
- Metrics enabled via `KC_METRICS_ENABLED=true`
- Health checks enabled via `KC_HEALTH_ENABLED=true`
- Log level set to `INFO` for production

## Next Steps
1. Deploy to your Kubernetes cluster
2. Configure proper SSL certificates
3. Set up monitoring and alerting
4. Configure backup strategies for the database
5. Set up realm and client configurations as needed
