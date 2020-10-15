#!/bin/bash
CUR_DIR=$(realpath `dirname ${BASH_SOURCE[0]}`)
source $CUR_DIR/config.sh

# exit when any command fails
set -e

# check build mode auto/man
BUILD_AUTO=${BUILD_AUTO:-1}

PROXY_ARG=""
if [ $HTTP_PROXY ]; then
    PROXY_ARG=" --env HTTP_PROXY=$HTTP_PROXY"
    echo "using http proxy: $HTTP_PROXY"
fi

if [ $HTTPS_PROXY ]; then
    PROXY_ARG="$PROXY_ARG --env HTTPS_PROXY=$HTTPS_PROXY"
    echo "using https proxy: $HTTPS_PROXY"
fi

if [ $PIP_INDEX ]; then
    PROXY_ARG="$PROXY_ARG --env PIP_INDEX=$PIP_INDEX"
fi

echo "compile paddle in docker"
echo "docker image: $BUILD_IMAGE"

BUILD_ID=$(docker images -q $BUILD_IMAGE)
if [ ! "$BUILD_ID" ]; then
    echo "docker image is not existed, and try to build."

    $CUR_DIR/build_docker.sh
fi

BUILD_NAME="paddle-musl-build-$(date +%Y%m%d-%H%M%S)"
echo "container name: $BUILD_NAME"

MOUNT_DIR="/paddle"
echo "mount paddle: $PADDLE_DIR => $MOUNT_DIR"


if [ "$BUILD_AUTO" -eq "1" ]; then
    echo "enter automatic build mode"

    # no exit when fails
    set +e

    BUILD_SCRIPT=$MOUNT_DIR/paddle/scripts/musl_build/build_inside.sh
    echo "build script: $BUILD_SCRIPT"

    docker run \
        -v $PADDLE_DIR:$MOUNT_DIR \
        --workdir /root \
        --network host $PROXY_ARG\
        --name $BUILD_NAME \
        $BUILD_IMAGE \
        $BUILD_SCRIPT $*

    echo "save output: $PWD/dist"
    docker cp $BUILD_NAME:/root/python/dist .

    echo "remove container: $BUILD_NAME"
    docker rm $BUILD_NAME
else
    echo "enter manual build mode"

    docker run \
        -it \
        -v $PADDLE_DIR:$MOUNT_DIR \
        --workdir /root \
        --network host $PROXY_ARG\
        --name $BUILD_NAME \
        $BUILD_IMAGE
fi
