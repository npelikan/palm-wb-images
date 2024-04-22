# NOTE: This Dockerfile has been provided by the community and is not officially built or supported by Posit.

FROM rockylinux:9
LABEL maintainer="Posit Docker <docker@posit.co>"

### ARG declarations ###
ARG R_VERSION=4.2.3
ARG R_VERSION_ALT=4.1.3
ARG PYTHON_VERSION=3.11.9
ARG PYTHON_VERSION_ALT=3.10.14
ARG TINI_VERSION=0.19.0
ARG QUARTO_VERSION=1.4.553
ARG DRIVERS_VERSION=2024.03.0-1

### Update/upgrade system packages ###
RUN dnf install -y -q dnf-plugins-core \
    && dnf config-manager --enable crb \
    && dnf upgrade -y -q \
    && dnf install -y -q \
      epel-release \
    && dnf install -y -q \
      bzip2 \
      git \
      glibc-common \
      glibc-langpack-en \
      glibc-locale-source \
      gpgme \
      gpgmepp \
      libcurl-devel \
      libuser-devel \
      libxml2-devel \
      openssl-devel \
      openssh-clients \
      pandoc \
      perl-Digest-MD5 \
      postgresql-libs \
      rrdtool \
      sudo \
      unixODBC \
      unixODBC-devel \
      wget \
      which \
    && dnf clean all

### Install tini ###
ADD https://cdn.rstudio.com/platform/tini/v${TINI_VERSION}/tini-amd64 /tini
ADD https://cdn.rstudio.com/platform/tini/v${TINI_VERSION}/tini-amd64.asc /tini.asc
RUN gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
    && gpg --batch --verify /tini.asc /tini \
    && chmod +x /tini \
    && ln -s /tini /usr/local/bin/tini

### Install TinyTeX ###
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh \
    && /root/.TinyTeX/bin/*/tlmgr path remove \
    && mv /root/.TinyTeX/ /opt/TinyTeX \
    && /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin \
    && /opt/TinyTeX/bin/*/tlmgr path add

### Install Quarto ###
RUN curl -o quarto.tar.gz -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz \
    && mkdir -p /opt/quarto/${QUARTO_VERSION} \
    && tar -zxvf quarto.tar.gz -C "/opt/quarto/${QUARTO_VERSION}" --strip-components=1 \
    && rm -f quarto.tar.gz \
    && ln -s /opt/quarto/${QUARTO_VERSION}/bin/quarto /usr/local/bin/quarto

### Install R versions ###
RUN curl -O https://cdn.rstudio.com/r/rhel-9/pkgs/R-${R_VERSION}-1-1.x86_64.rpm \
    && curl -O https://cdn.rstudio.com/r/rhel-9/pkgs/R-${R_VERSION_ALT}-1-1.x86_64.rpm \
    && dnf install -y R-${R_VERSION}-1-1.x86_64.rpm \
    && dnf install -y R-${R_VERSION_ALT}-1-1.x86_64.rpm \
    && dnf clean all \
    && rm -rf R-${R_VERSION}-1-1.x86_64.rpm \
    && rm -rf R-${R_VERSION_ALT}-1-1.x86_64.rpm \
    && ln -s /opt/R/${R_VERSION} /opt/R/default \
    && ln -s /opt/R/default/bin/R /usr/local/bin/R \
    && ln -s /opt/R/default/bin/Rscript /usr/local/bin/Rscript

### Install Python versions ###
RUN curl -O https://cdn.rstudio.com/python/rhel-9/pkgs/python-${PYTHON_VERSION}-1-1.x86_64.rpm \
    && curl -O https://cdn.rstudio.com/python/rhel-9/pkgs/python-${PYTHON_VERSION_ALT}-1-1.x86_64.rpm \
    && dnf install -y python-${PYTHON_VERSION}-1-1.x86_64.rpm \
    && dnf install -y python-${PYTHON_VERSION_ALT}-1-1.x86_64.rpm \
    && dnf clean all \
    && rm -rf python-${PYTHON_VERSION}-1-1.x86_64.rpm \
    && rm -rf python-${PYTHON_VERSION_ALT}-1-1.x86_64.rpm \
    && /opt/python/${PYTHON_VERSION}/bin/python3 -m pip install 'virtualenv<20' \
    && /opt/python/${PYTHON_VERSION}/bin/python3 -m pip install --upgrade setuptools \
    && /opt/python/${PYTHON_VERSION_ALT}/bin/python3 -m pip install 'virtualenv<20' \
    && /opt/python/${PYTHON_VERSION_ALT}/bin/python3 -m pip install --upgrade setuptools \
    && ln -s /opt/python/${PYTHON_VERSION} /opt/python/default

### Locale configuration ###
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN curl -o drivers.rpm -L https://cdn.rstudio.com/drivers/7C152C12/installer/rstudio-drivers-${DRIVERS_VERSION}.el.x86_64.rpm

RUN dnf install -y drivers.rpm \
    && dnf clean all \
    && rm -f drivers.rpm \
    && cp /opt/rstudio-drivers/odbcinst.ini.sample /etc/odbcinst.ini \
    && "/opt/R/${R_VERSION}/bin/R" -e 'install.packages("odbc", repos="https://packagemanager.rstudio.com/cran/__linux__/rhel9/latest")'

LABEL posit.r.version="${R_VERSION}" \
      posit.r.version_alt="${R_VERSION_ALT}" \
      posit.python.version="${PYTHON_VERSION}" \
      posit.python.version_alt="${PYTHON_VERSION_ALT}" \
      posit.tini.version="${TINI_VERSION}" \
      posit.quarto.version="${QUARTO_VERSION}" \
      rstudio.pro-drivers.version="${DRIVERS_VERSION}"

LABEL org.opencontainers.image.source=https://github.com/npelikan/palm-wb-images


ENTRYPOINT ["/tini", "--"]