FROM postgis/postgis:15-3.4

# Copy initialization files
COPY initdb/ /docker-entrypoint-initdb.d/

# Ensure scripts are executable
RUN chmod +x /docker-entrypoint-initdb.d/*.sh
