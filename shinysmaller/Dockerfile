FROM rocker/shiny:4.6
RUN /rocker_scripts/install_geospatial.sh

RUN apt-get update && apt-get install -y \
    curl 

COPY install_scripts/ install_scripts/
RUN chmod -R +x install_scripts/
RUN install_scripts/install_r_packages.sh

# Remove app default shiny
RUN rm -rf /srv/shiny-server/*

# Fix permissions
RUN mkdir -p /srv/shiny-server/app_cache \
 && chown -R shiny:shiny /srv/shiny-server

# Better logging
ENV SHINY_LOG_STDERR=1

# Expose Shiny port
EXPOSE 3838

# Run Shiny server
CMD ["/usr/bin/shiny-server"]