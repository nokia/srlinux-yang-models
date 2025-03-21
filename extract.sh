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

checkout_orphan_branch() {
    # checkout to the main branch as a starting point
    git checkout main

    # branch name includes first two parts of the version number
    # e.g. for SRL_VER=24.3.2 it will be v24.3
    local branch_name=v${SRL_VER%.*}

    # Fetch the latest references from the remote repository
    git fetch

    # Check if the branch exists locally or remotely
    if ! git show-ref --verify --quiet refs/heads/$branch_name && \
       ! git show-ref --verify --quiet refs/remotes/origin/$branch_name; then
        # If the branch does not exist, create and checkout an orphan branch
        echo "Branch $branch_name does not exist, creating..."
        git checkout --orphan $branch_name
        # move the license file to the tmp so that we can move it back and not remove
        mv LICENSE /tmp/LICENSE
        git rm -rf .
        # Restore the LICENSE file
        mv /tmp/LICENSE LICENSE

        # create a README.md file
        cat > README.md <<'EOF'
# SR Linux YANG models

This branch contains the source `.yang` files for Nokia SR Linux Network OS release .

Check the readme file in the [`main`](https://github.com/nokia/srlinux-yang-models/blob/main/README.md) branch for details on how to navigate this repo.
EOF

    else
        echo "Branch $branch_name already exists, checking out..."
        # If the branch exists, just checkout
        git checkout $branch_name
    fi
}

# checkout to the orphan branch for a major release
checkout_orphan_branch

DIR_NAME="$(pwd)/srlinux-yang-models"
# if pull is not successful, assume that image is present locally
docker pull ghcr.io/nokia/srlinux:$1 || echo "using local image"
id=$(docker create ghcr.io/nokia/srlinux:$SRL_VER foo)
# remove prev yang files
rm -rf $DIR_NAME
mkdir -p $DIR_NAME
docker cp $id:/opt/srlinux/models/. $DIR_NAME
# copy mappings
docker cp $id:/opt/srlinux/mappings $DIR_NAME
# copy oc deviations
docker cp $id:/opt/srlinux/deviations/openconfig/openconfig-srl-deviations.yang $DIR_NAME/openconfig

# remove unused files
rm -f $DIR_NAME/*.j2
rm -f $DIR_NAME/*snip

docker rm $id