#!/bin/sh
PADDLE_DIR=/paddle
BUILD_DIR=$PWD
VENV_DIR=$BUILD_DIR/venv

echo "paddle: $PADDLE_DIR"
echo "python: $PYTHON_VERSION"
echo "http_proxy: $HTTP_PROXY"
echo "https_proxy: $HTTPS_PROXY"

# exit when any command fails
set -e

echo "create build dir: $BUILD_DIR"
mkdir -p $BUILD_DIR

if [ $HTTP_PROXY ]; then
    git config --global http.proxy $HTTP_PROXY
fi

if [ $HTTP_PROXY ]; then
    git config --global https.proxy $HTTPS_PROXY
fi

PIP_ARGS=""
if [ $PIP_INDEX ]; then
    PIP_DOMAIN=$(echo $PIP_INDEX| awk -F/ '{print $3}')
    PIP_ARGS="-i $PIP_INDEX --trusted-host $PIP_DOMAIN"
    echo "pip index: $PIP_INDEX"
fi

PYTHON_REQS=$PADDLE_DIR/python/requirements.txt
echo "install python requirements: $PYTHON_REQS"
pip install $PIP_ARGS --timeout 300 --no-cache-dir -r $PYTHON_REQS

echo "configure with cmake"
cd $BUILD_DIR
cmake $PADDLE_DIR \
    -DWITH_MUSL=ON \
    -DWITH_CRYPTO=OFF \
    -DWITH_MKL=OFF \
    -DWITH_GPU=OFF \
    -DWITH_TESTING=OFF

echo "compile with make: $*"
make $*
