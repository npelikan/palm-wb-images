FROM ubuntu:jammy

ARG R_VERSION=4.3.2
ARG QUARTO_VERSION=1.4.553

RUN apt-get update -y \ 
    && apt-get install -y curl gdebi-core \
    && curl -O https://cdn.rstudio.com/r/ubuntu-2204/pkgs/r-${R_VERSION}_1_amd64.deb \
    && gdebi -n r-${R_VERSION}_1_amd64.deb \
    && rm r-${R_VERSION}_1_amd64.deb \
    && curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && gdebi -n ./quarto-linux-amd64.deb \
    && rm quarto-linux-amd64.deb

LABEL org.opencontainers.image.source=https://github.com/npelikan/palm-wb-images
