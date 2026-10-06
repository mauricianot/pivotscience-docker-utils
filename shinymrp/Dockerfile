FROM rocker/shiny:latest

# 1. Dépendances système complètes (Ajout des dépendances pour s2, textshaping et PROJ data)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    proj-data \
    proj-bin \
    libudunits2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libv8-dev \
    libprotobuf-dev \
    protobuf-compiler \
    default-jdk \
    libglpk-dev \
    libgit2-dev \
    libpng-dev \
    libtiff-dev \
    libjpeg-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Configuration de Java pour R (indispensable pour OpenStreetMap / rJava)
RUN R CMD javareconf

# Définir le dossier des packages R dans un espace partagé et accessible
ENV R_LIBS_USER=/usr/local/lib/R/site-library

# 3. Installer le reste des packages R
RUN R -e "install.packages(c( \
  # Shiny core
  'shiny','shinydashboard','shinydashboardPlus','shinyWidgets', \
  'shiny.i18n','shinyjs','shinycssloaders','shinyBS','bslib','shinymanager', \
  # Data manipulation
  'dplyr','purrr','plyr','reshape','lubridate','jsonlite','rjson', \
  # Spatial (sans sf qui est déjà installé)
  'htmlwidgets','raster','OpenStreetMap', \
  # Async / performance
  'promises','ipc', \
  # Statistics
  'mgcv', \
  # Plot
  'ggplot2','ggrepel', 'prettymapr', \
  # Reporting
  'rmarkdown', 'knitr', 'pander', \
  # Utilities
  'dipsaus' \
), repos='https://cloud.r-project.org', dependencies=TRUE)"

# Install rpostgis from GitHub
RUN R -e "install.packages('remotes', repos='https://cloud.r-project.org/')"
RUN R -e "remotes::install_cran('leaflet')"
RUN R -e "remotes::install_cran('leaflet.extras')"
RUN R -e "remotes::install_cran('bsicons')"
RUN R -e "remotes::install_cran('rpostgis')"
RUN R -e "remotes::install_cran('osrm')"
RUN R -e "remotes::install_cran('ggpubr')"
RUN R -e "remotes::install_cran('ggspatial')" 
RUN R -e "remotes::install_cran('leafem')"
RUN R -e "remotes::install_cran('RPostgres')"

# Nettoyer le répertoire par défaut de Shiny
RUN rm -rf /srv/shiny-server/*

# Cloner le dépôt de l'application
RUN git clone https://github.com/mauricianot/mrp-shiny.git /srv/shiny-server

# Fixer TOUS les droits pour l'utilisateur shiny sur son répertoire applicatif
RUN mkdir -p /srv/shiny-server/app_cache \
 && chown -R shiny:shiny /srv/shiny-server \
 && chmod -R 755 /srv/shiny-server

# Variables d'environnement pour une exécution stable de Shiny
ENV SHINY_LOG_STDERR=1
ENV R_HOME=/usr/lib/R

# Exposer le port Shiny
EXPOSE 3838

# Lancer l'application sous l'utilisateur natif 'shiny' pour éviter les conflits root
USER shiny

CMD ["/usr/bin/shiny-server"]
