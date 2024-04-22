#!/bin/bash

IFS=' '
read -ra version_arr <<< "$1"
for PYTHON_VERSION in version_arr
do
    curl -O https://cdn.rstudio.com/python/ubuntu-2204/pkgs/python-${PYTHON_VERSION}_1_amd64.deb
    apt-get install -yq --no-install-recommends ./python-${PYTHON_VERSION}_1_amd64.deb
    rm -rf python-${PYTHON_VERSION}_1_amd64.deb
    pypath = "/opt/python/${PYTHON_VERSION}/bin/python3"
    eval $pypath -m pip install --upgrade 'virtualenv<20' setuptools
    echo "Installed Py v${PYTHON_VERSION}"
done