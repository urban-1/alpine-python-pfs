FROM alpine:latest

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ARG PYTHON_VERSION=3.4.3
ARG PYTHON_PIP_VERSION=9.0.1

# Instal build requirements
RUN apk update && \
    apk add --no-cache --virtual .build-deps  \
    g++ \
    libc-dev \
    linux-headers \
    make \
    tcl-dev \
    tk \
    tk-dev \
    git \
    wget \
    perl \
    file \
    pkgconfig && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/urban-1/PFS.git && \
    cd PFS && \
    sh ./pfs.sh -s /tmp -p /usr -v ${PYTHON_VERSION} -d && \
    cd .. && \
    rm -rf /tmp/* && \
    apk del .build-deps && \
    find /usr/local -depth \
            \( \
                \( -type d -a -name test -o -name tests \) \
                -o \
                \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
            \) -exec rm -rf '{}' + \
    && find /usr/local/lib/python* -name *.a -exec rm {} + 

# Do some linking...
RUN if [ ! -f /usr/local/bin/python ]; then \
        ln -s /usr/local/bin/python$(echo ${PYTHON_VERSION}|cut -d'.' -f1) /usr/local/bin/python; \
    fi
    

ENTRYPOINT ["/bin/sh"]
