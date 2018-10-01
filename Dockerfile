FROM ubuntu:18.04

LABEL maintainer "Santiago Alessandri <san.lt.ss@gmail.com>"

ARG CONAN_VERSION=1.7.4

RUN apt update && \
    apt install -y --no-install-recommends \
        git \
        ca-certificates \
        python3  \
        python3-pip \
        python3-setuptools && \
    cd /opt/ && \
    git clone --branch ${CONAN_VERSION} --depth 1 https://github.com/conan-io/conan.git && \
    cd /opt/conan && \
    pip3 install -r conans/requirements.txt && \
    pip3 install -r conans/requirements_server.txt && \
    pip3 install gunicorn && \
    apt remove --purge -y \
        git \
        ca-certificates \
        python3-pip && \
    apt autoremove --purge -y && \
    rm -r /var/lib/apt/lists/*

EXPOSE 9300

WORKDIR /opt/conan

CMD ["gunicorn", \
     "-b", "0.0.0.0:9300", \
     "-w", "4", \
     "-t", "300", \
     "conans.server.server_launcher:app"]
