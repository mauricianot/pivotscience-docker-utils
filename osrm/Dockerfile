# Base image
FROM osrm/osrm-backend:latest-assertions

# Copy data-osm extracted by osmium-tool and set working directory
COPY data-osrm/ /data/ 
WORKDIR /data

# OSRM extracting and contracting
RUN osrm-extract -p /opt/foot.lua database_osrm_pivot.pbf && \
    osrm-contract database_osrm_pivot.osrm

EXPOSE 5000

CMD ["osrm-routed", "--max-table-size", "100000", "database_osrm_pivot.osrm"]
