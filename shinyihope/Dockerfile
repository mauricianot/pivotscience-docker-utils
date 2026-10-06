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
  'shiny.i18n', \
  'bslib', \
  'shinyjs', \
  'shinydashboard', \
  'shinycssloaders', \
  'htmlwidgets', \
  'ggplot2', \
  'sf', \
  'dplyr', \
  'palmerpenguins', \
  'plotly', \
  'jsonlite', \
  'gstat', \
  'RColorBrewer', \
  'spdep', \
  'SDMTools', \
  'survey', \
  'remotes' \
), repos='https://cloud.r-project.org/')"

# Install decomp from R-Forge and GitHub
RUN R -e "install.packages(c('decomp'), repos='http://R-Forge.R-project.org')"
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org/')"
RUN R -e "remotes::install_cran('DT')"
RUN R -e "remotes::install_cran('gridExtra')"

# Remove app default shiny
RUN rm -rf /srv/shiny-server/*

# Clone repository and copy app into container
RUN git clone https://github.com/mauricianot/ihope-shiny.git /srv/shiny-server

# Fix permissions
RUN mkdir -p /srv/shiny-server/app_cache \
 && chown -R shiny:shiny /srv/shiny-server

# Better logging
ENV SHINY_LOG_STDERR=1

# Expose Shiny port
EXPOSE 3838

# Run Shiny server
CMD ["/usr/bin/shiny-server"]