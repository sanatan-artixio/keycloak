# Use the official Keycloak image
FROM keycloak/keycloak:latest

# Set the working directory
WORKDIR /opt/keycloak

# Copy any custom themes or configurations if needed
# COPY themes/ /opt/keycloak/themes/
# COPY providers/ /opt/keycloak/providers/

# Build Keycloak (optimizes the server for production)
RUN /opt/keycloak/bin/kc.sh build

# Expose the default Keycloak port
EXPOSE 8080

# Set the entrypoint to start Keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start-dev"]
