FROM alpine:latest

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ARG PYTHON_VERSION=3.4.3
ARG PYTHON_PIP_VERSION=9.0.1

# Instal build requirements
RUN apk add --no-cache --virtual .build-deps  \
    coreutils \
    gcc \
    libc-dev \
    linux-headers \
    make \
    tcl-dev \
    tk \
    tk-dev \
    git \
    wget

RUN mkdir -p /dev/shm/pfs/src && \
    cd /dev/shm/pfs/src && \
    git clone https://github.com/urban-1/PFS.git && \
    cd PFS && \
    sh ./pfs.sh -p /usr/local -v ${PYTHON_VERSION} && \
    cd .. && \
    rm -rf /dev/shm/pfs/src
    


CMD ["python3"]
