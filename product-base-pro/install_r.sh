#!/bin/bash

IFS=','
read -a version_arr <<< "$1"
for R_VERSION in $version_arr
do
    curl -O https://cdn.rstudio.com/r/ubuntu-2204/pkgs/r-${R_VERSION}_1_amd64.deb
    apt-get install -yq --no-install-recommends ./r-${R_VERSION}_1_amd64.deb
    rm -f ./r-${R_VERSION}_1_amd64.deb
    eval "/opt/R/${R_VERSION}/bin/R" -e 'install.packages("odbc", repos="https://packagemanager.rstudio.com/cran/__linux__/jammy/latest")'
    echo "Installed R v${R_VERSION}"
done