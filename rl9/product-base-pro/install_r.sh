#!/bin/bash

IFS=','
version_arr=$1
for R_VERSION in ${version_arr[@]}
do
    curl -O https://cdn.rstudio.com/r/rhel-9/pkgs/R-${R_VERSION}-1-1.x86_64.rpm
    dnf install -y R-${R_VERSION}-1-1.x86_64.rpm
    rm -rf R-${R_VERSION}-1-1.x86_64.rpm
    eval "/opt/R/${R_VERSION}/bin/R" -e 'install.packages("odbc", repos="https://packagemanager.rstudio.com/cran/__linux__/jammy/latest")'
    echo "Installed R v${R_VERSION}"
done