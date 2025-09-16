# Multi-stage build following official Keycloak best practices
FROM quay.io/keycloak/keycloak:latest AS builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak

# Generate self-signed certificate for production (replace with proper certs in production)
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 \
    -dname "CN=keycloak.artixio.com" -alias server \
    -ext "SAN:c=DNS:keycloak.artixio.com,DNS:localhost,IP:127.0.0.1" \
    -keystore conf/server.keystore

# Copy any custom themes or configurations if needed
# COPY themes/ /opt/keycloak/themes/
# COPY providers/ /opt/keycloak/providers/

# Build Keycloak (optimizes the server for production)
RUN /opt/keycloak/bin/kc.sh build

# Final stage - create optimized production image
FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Set production environment variables for service mesh architecture
ENV KC_DB=postgres
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME_STRICT_HTTPS=false
ENV KC_HTTP_ENABLED=true

# Expose HTTP and metrics ports (HTTPS handled by service mesh)
EXPOSE 8080 9000

# Set the entrypoint to enable all distribution sub-commands
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
