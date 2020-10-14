#!/bin/bash
CUR_DIR=$(realpath `dirname ${BASH_SOURCE[0]}`)
source $CUR_DIR/config.sh

# exit when any command fails
set -e

PROXY_ARG=""
if [ $HTTP_PROXY ]; then
    PROXY_ARG=" --build-arg http_proxy=$HTTP_PROXY"
    echo "using http proxy: $HTTP_PROXY"
fi

if [ $HTTPS_PROXY ]; then
    PROXY_ARG="$PROXY_ARG --build-arg https_proxy=$HTTPS_PROXY"
    echo "using https proxy: $HTTPS_PROXY"
fi

echo "clean up docker images: $BUILD_IMAGE"
docker rmi -f $BUILD_IMAGE

echo "build docker image: $BUILD_IMAGE"
docker build \
    -t $BUILD_IMAGE \
    -f $CUR_DIR/Dockerfile \
    --rm=false \
    --network host $PROXY_ARG \
    --output type=tar,dest=buld.tar \
    .
