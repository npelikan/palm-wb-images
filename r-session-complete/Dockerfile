ARG SRC_IMAGE_NAME=product-base-pro
ARG SRC_IMAGE_STUB=latest-py
ARG REGISTRY=ghcr.io
FROM ghcr.io/npelikan/${SRC_IMAGE_NAME}:ubuntu2204-${SRC_IMAGE_STUB}
LABEL maintainer="RStudio Docker <docker@rstudio.com>"

ARG DEBIAN_FRONTEND=noninteractive
ARG R_VERSION=4.2.3
ARG R_VERSION_ALT=4.1.3
ARG PYTHON_VERSION=3.11.9
ARG PYTHON_VERSION_ALT=3.10.14
ARG JUPYTERLAB_VERSION=3.6.5
ARG RSW_VERSION=2024.04.0-daily-693.pro11
ARG RSW_NAME=rstudio-workbench
ARG RSW_DOWNLOAD_URL=https://s3.amazonaws.com/rstudio-ide-build/server/jammy/amd64

ENV WORKBENCH_JUPYTER_PATH=/usr/local/bin/jupyter

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      krb5-user \
      libcurl4-gnutls-dev \
      libuser \
      libuser1-dev \
      libpq-dev \
      rrdtool \
      subversion \
      libzmq3-dev \
      libgit2-dev \
    && RSW_VERSION_URL=$(echo -n "${RSW_VERSION}" | sed 's/+/-/g') \
    && curl -o rstudio-workbench.deb "${RSW_DOWNLOAD_URL}/${RSW_NAME}-${RSW_VERSION_URL}-amd64.deb" \
    # Pre 7/25/23 packages
    && gpg --keyserver keyserver.ubuntu.com --recv-keys 3F32EE77E331692F \
    # Post 7/25 packages
    && gpg --keyserver keys.openpgp.org --recv-keys 51C0B5BB19F92D60 \
    && apt-get install -yq --no-install-recommends ./rstudio-workbench.deb \
    && rm ./rstudio-workbench.deb \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/rstudio-server/r-versions


RUN /opt/python/"${PYTHON_VERSION}"/bin/pip install \
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

LABEL org.opencontainers.image.source=https://github.com/npelikan/palm-wb-images

COPY vscode.extensions.conf /etc/rstudio/vscode.extensions.conf

EXPOSE 8788/tcp
