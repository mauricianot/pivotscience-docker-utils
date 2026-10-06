#!/bin/bash

# step 1: Download data OSM Madagascar 
echo "Download data OSM Madagascar and prepare for OSRM" 
wget -O ./osrm/data-osrm/madagascar-latest.osm.pbf https://download.geofabrik.de/africa/madagascar-latest.osm.pbf 

# step 2: Install osmium tool for extact data OSM Madagascar for District of southern Madagascar 
echo "Install osmium tool for prepare data OSM Madagascar for OSRM" 
sudo apt-get update 
sudo apt-get install osmium-tool 

# step 3: Create folder data-osrm
mkdir ./osrm/data-osrm

# step 4: Extract southern Madagascar bounding box
echo "Extracting data for southern Madagascar..." 
sudo osmium extract -b 47.00293,-20.156099,48.636998,-24.204999 \
    ./osrm/data-osrm/madagascar-latest.osm.pbf -o ./osrm/data-osrm/database_osrm_pivot.pbf