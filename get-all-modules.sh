#!/bin/sh

# export all available YANG modules in a flat dir structure
# with a dir per SR Linux YANG module version.

# usage:
# to extract all modules to the $(pwd)/all directory:
# ./get-all-modules.sh

# to extract to a custom directory
# TARGET_DIR=/tmp/all ./get-all-modules.sh

set -e

# target directory which nests all extracted modules
TARGET_DIR=${TARGET_DIR:-$(pwd)/all}

# create target dir
mkdir -p ${TARGET_DIR}

ALL_TAGS=$(git tag)

# Loop over each tag and extract the models
for tag in ${ALL_TAGS}
do
  echo "\n\nExtracting ${tag} models"
  mkdir -p ${TARGET_DIR}/${tag}
  git checkout ${tag}
  cp -a srlinux-yang-models/* all/${tag}
done

# go back to main
git checkout main