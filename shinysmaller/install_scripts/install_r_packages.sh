#!/bin/bash
set -e

## build ARGs
NCPUS=${NCPUS:--1}


install2.r --error --skipinstalled -n "$NCPUS" \
    leaflet \
    attempt \
    DT \
    glue \
    golem \
    htmltools \
    pkgload \
    plotly \
    scales \
    shinyWidgets \
    stringr \
    rmarkdown \
    reactable \
    paletteer \
    qs2 \
    bslib \
    fontawesome \
    shinydashboard \
    shinydashboardPlus \
    lubridate \
    markdown


# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

## Strip binary installed lybraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so