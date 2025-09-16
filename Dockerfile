# Use the official Keycloak image
FROM quay.io/keycloak/keycloak:latest

# Switch to root to install packages
USER root

# Install useful tools and utilities
RUN microdnf update -y && \
    microdnf install -y \
        nano \
        vim \
        htop \
        curl \
        wget \
        net-tools \
        procps-ng \
        bash \
        bash-completion \
        tree \
        less \
        findutils \
        grep \
        sed \
        gawk \
        tar \
        gzip \
        unzip && \
    microdnf clean all

# Set the working directory
WORKDIR /opt/keycloak

# Copy any custom themes or configurations if needed
# COPY themes/ /opt/keycloak/themes/
# COPY providers/ /opt/keycloak/providers/

# Set user back to keycloak
USER keycloak

# Build Keycloak (optimizes the server for production)
RUN /opt/keycloak/bin/kc.sh build

# Expose the default Keycloak port
EXPOSE 8080

# Set the entrypoint to start Keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start-dev"]
