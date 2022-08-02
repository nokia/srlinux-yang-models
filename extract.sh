#!/bin/bash

# Copyright 2020 Nokia
# Licensed under the BSD 3-Clause License.
# SPDX-License-Identifier: BSD-3-Clause

# this script extracts YANG files from srlinux public container image
# usage: bash extract.sh $srlVersion
# example: bash extract.sh 21.6.3

set -e

if [ -z "$1" ]; then
    echo "srlinux version is not set. usage: bash extract.sh <version>"
    exit 1
fi

SRL_VER=$1

DIR_NAME="$(pwd)/srlinux-yang-models"
# if pull is not successfull, assume that image is present locally
docker pull ghcr.io/nokia/srlinux:$1 || echo "using local image"
id=$(docker create ghcr.io/nokia/srlinux:$SRL_VER foo)
# remove prev yang files
rm -rf $DIR_NAME
mkdir -p $DIR_NAME
docker cp $id:/opt/srlinux/models/. $DIR_NAME

# remove j2 configs as they are not related to yang models
rm -f $DIR_NAME/*.j2

docker rm $id
