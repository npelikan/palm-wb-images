#!/bin/bash

IFS=','
version_arr=$1
for PYTHON_VERSION in ${version_arr[@]}
do
    curl -O https://cdn.rstudio.com/python/rhel-9/pkgs/python-${PYTHON_VERSION}-1-1.x86_64.rpm
    dnf install -y python-${PYTHON_VERSION}-1-1.x86_64.rpm
    rm -rf python-${PYTHON_VERSION}-1-1.x86_64.rpm
    pypath = "/opt/python/${PYTHON_VERSION}/bin/python3"
    eval $pypath -m pip install --upgrade 'virtualenv<20' setuptools
    echo "Installed Py v${PYTHON_VERSION}"
done