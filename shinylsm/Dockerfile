FROM rocker/shiny:latest

# System dependencies (important for sf, raster, Postgres, leaflet)
RUN apt-get update && apt-get install -y \
    git \
    libuv1 \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libpq-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    gdal-bin \
    proj-bin \
    libudunits2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c( \
  'shiny', \
  'shiny.i18n', \
  'bslib', \
  'thematic', \
  'DBI', \
  'RPostgres', \
  'plotly', \
  'ggplot2', \
  'sf', \
  'dplyr', \
  'raster', \
  'htmlwidgets', \
  'viridis' \
), repos='https://cloud.r-project.org/')"

# Install rpostgis from GitHub
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org/')"
RUN R -e "remotes::install_cran('leaflet')"
RUN R -e "remotes::install_cran('leaflet.extras')"
RUN R -e "remotes::install_cran('bsicons')"
RUN R -e "remotes::install_cran('rpostgis')"

# Remove app default shiny
RUN rm -rf /srv/shiny-server/*

# Clone repository and copy app into container
RUN git clone https://github.com/mauricianot/lsm-shiny.git /srv/shiny-server

# Fix permissions
RUN mkdir -p /srv/shiny-server/app_cache \
 && chown -R shiny:shiny /srv/shiny-server

# Better logging
ENV SHINY_LOG_STDERR=1

# Expose Shiny port
EXPOSE 3838

# Run Shiny server
CMD ["/usr/bin/shiny-server"]