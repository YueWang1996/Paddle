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

#echo "create venv dir: $VENV_DIR"
#python -m venv --system-site-packages $VENV_DIR
#source $VENV_DIR/bin/activate

PIP_ARGS=""
if [ $PIP_INDEX ]; then
    PIP_ARGS="-i $PIP_INDEX"
    echo "pip index: $PIP_INDEX"
fi

PYTHON_REQS=$PADDLE_DIR/python/requirements.txt
echo "install python requirements: $PYTHON_REQS"
pip install $PIP_ARGS -r $PYTHON_REQS

echo "configure with cmake"
cd $BUILD_DIR
cmake $PADDLE_DIR \
    -DWITH_MUSL=ON \
    -DWITH_CRYPTO=OFF \
    -DWITH_MKL=OFF \
    -DWITH_GPU=OFF \
    -DWITH_TESTING=OFF

echo "compile with make"
make $*
