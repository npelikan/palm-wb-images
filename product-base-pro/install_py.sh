#!/bin/bash

IFS=','
version_arr=$1
for PYTHON_VERSION in ${version_arr[@]}
do
    curl -O https://cdn.rstudio.com/python/ubuntu-2204/pkgs/python-${PYTHON_VERSION}_1_amd64.deb
    apt-get install -yq --no-install-recommends ./python-${PYTHON_VERSION}_1_amd64.deb
    rm -rf python-${PYTHON_VERSION}_1_amd64.deb
    eval "/opt/python/${PYTHON_VERSION}/bin/python3 -m pip install --upgrade 'virtualenv<20' setuptools"
    echo "Installed Py v${PYTHON_VERSION}"
done