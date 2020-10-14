#!/bin/bash
CUR_DIR=$(realpath `dirname ${BASH_SOURCE[0]}`)
PADDLE_DIR=$(realpath $CUR_DIR/../../../)

BUILD_IMAGE="paddle-musl-build:2.0"
