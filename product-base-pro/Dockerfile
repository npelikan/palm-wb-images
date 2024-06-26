FROM ubuntu:22.04

### ARG declarations ###
ARG DEBIAN_FRONTEND=noninteractive
ARG R_VERSIONS="4.4.0,4.3.2,4.2.3,4.1.3,4.0.5"
ARG DEFAULT_R_VERSION=4.4.0
ARG PYTHON_VERSIONS="3.12.3,3.11.9,3.10.14,3.9.19,3.8.19"
ARG DEFAULT_PYTHON_VERSION=3.11.9
ARG TINI_VERSION=0.19.0
ARG QUARTO_VERSION=1.4.553
ARG DRIVERS_VERSION=2024.03.0


### Update/upgrade system packages ###
RUN apt-get update --fix-missing  \
    && apt-get upgrade -yq \
    && apt-get install -yq --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        cmake \
        cracklib-runtime \
        curl \
        default-jdk \
        dirmngr \
        dpkg-sig \
        g++ \
        gcc \
        gdal-bin \
        gfortran \
        git \
        gpg \
        gpg-agent \
        gsfonts \
        imagemagick \
        libcairo2-dev \
        libcurl4-openssl-dev \
        libev-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libfribidi-dev \
        libgdal-dev \
        libgeos-dev \
        libgl1-mesa-dev \
        libglpk-dev \
        libglu1-mesa-dev \
        libgmp3-dev \
        libharfbuzz-dev \
        libicu-dev \
        libjpeg-dev \
        libmagick++-dev \
        libmysqlclient-dev \
        libopenblas-dev \
        libpaper-utils \
        libpcre2-dev \
        libpng-dev \
        libproj-dev \
        libsodium-dev \
        libssh2-1-dev \
        libssl-dev \
        libtiff-dev \
        libudunits2-dev \
        libv8-dev \
        libxml2-dev \
        locales \
        make \
        openssh-client \
        pandoc \
        perl \
        sudo \
        tcl \
        tk \
        tk-dev \
        tk-table \
        tzdata \
        unixodbc-dev \
        unzip \
        wget \
        zip \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

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

RUN apt-get update \
    && apt-get install -yq --no-install-recommends unixodbc unixodbc-dev \
    && curl -O https://cdn.rstudio.com/drivers/7C152C12/installer/rstudio-drivers_${DRIVERS_VERSION}_amd64.deb \
    && apt-get update \
    && apt-get install -yq --no-install-recommends ./rstudio-drivers_${DRIVERS_VERSION}_amd64.deb \
    && rm -f ./rstudio-drivers_${DRIVERS_VERSION}_amd64.deb \
    && rm -rf /var/lib/apt/lists/* \
    && cp /opt/rstudio-drivers/odbcinst.ini.sample /etc/odbcinst.ini

### Install R versions ###
COPY install_r.sh ./install_r.sh
COPY install_packages.r ./install_packages.r
RUN chmod +x ./install_r.sh \
    && ./install_r.sh ${R_VERSIONS} \
    && ln -s /opt/R/${DEFAULT_R_VERSION} /opt/R/default \
    && ln -s /opt/R/default/bin/R /usr/local/bin/R \
    && ln -s /opt/R/default/bin/Rscript /usr/local/bin/Rscript

### Install Python versions ###
COPY install_py.sh ./install_py.sh
RUN chmod +x ./install_py.sh \
    && ./install_py.sh ${PYTHON_VERSIONS} \
    && ln -s /opt/python/${DEFAULT_PYTHON_VERSION} /opt/python/default

### Locale configuration ###
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ UTC

### Clean up ###
RUN apt-get install -yqf --no-install-recommends \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/tini", "--"]
