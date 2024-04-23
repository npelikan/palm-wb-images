ARG SRC_IMAGE_NAME=product-base-pro
ARG SRC_IMAGE_STUB=latest
FROM ghcr.io/npelikan/${SRC_IMAGE_NAME}:rl9-${SRC_IMAGE_STUB}

### ARG declarations ###
ARG R_VERSION=4.2.3
ARG R_VERSION_ALT=4.1.3
ARG PYTHON_VERSION=3.11.9
ARG PYTHON_VERSION_ALT=3.10.14
ARG JUPYTERLAB_VERSION=3.6.5
ARG RSW_VERSION=2024.04.0-725.pro7

### Install RSW
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN dnf install -y subversion
RUN curl -o ./pwb.rpm "https://s3.amazonaws.com/rstudio-ide-build/server/rhel9/x86_64/rstudio-workbench-rhel-${RSW_VERSION}-x86_64.rpm" \
    && dnf install -y ./pwb.rpm \
    && rm ./pwb.rpm \
    && dnf clean all \
    && rm -rf /var/lib/rstudio-server/r-versions

### Install jupyter
RUN /opt/python/"${PYTHON_VERSION}"/bin/pip3 install \
      jupyter \
      jupyterlab=="${JUPYTERLAB_VERSION}" \
      rsconnect_jupyter \
      rsconnect_python \
      rsp_jupyter \
      workbench_jupyterlab \
    && ln -s /opt/python/"${PYTHON_VERSION}"/bin/jupyter /usr/local/bin/jupyter \
    && /opt/python/"${PYTHON_VERSION}"/bin/jupyter-nbextension install --sys-prefix --py rsp_jupyter \
    && /opt/python/"${PYTHON_VERSION}"/bin/jupyter-nbextension enable --sys-prefix --py rsp_jupyter \
    && /opt/python/"${PYTHON_VERSION}"/bin/jupyter-nbextension install --sys-prefix --py rsconnect_jupyter \
    && /opt/python/"${PYTHON_VERSION}"/bin/jupyter-nbextension enable --sys-prefix --py rsconnect_jupyter \
    && /opt/python/"${PYTHON_VERSION}"/bin/jupyter-serverextension enable --sys-prefix --py rsconnect_jupyter

ENV PATH="/opt/python/${PYTHON_VERSION}/bin:${PATH}"

COPY vscode.extensions.conf /etc/rstudio/vscode.extensions.conf

EXPOSE 8788/tcp