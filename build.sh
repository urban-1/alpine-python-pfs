#!/bin/bash

DN=$(readlink -f $(dirname "$0"))
VERSION=$(cat "$DN/VERSION")

PYVER=3.4.3

if [ $# -gt 0 ]; then
    PYVER=$1
fi

PYVER_SHORT=$(echo $PYVER | cut -d'.' -f1,2)

echo
echo "Building with:"
echo
echo "  docker build -t urban1/alpine-pfs$PYVER_SHORT -t urban1/alpine-pfs$PYVER_SHORT:$VERSION --build-arg PYTHON_VERSION=$PYVER ."
echo

docker build -t urban1/alpine-python-pfs:latest-$PYVER_SHORT -t urban1/alpine-python-pfs:$VERSION-$PYVER_SHORT --build-arg PYTHON_VERSION=$PYVER .

exit $?
