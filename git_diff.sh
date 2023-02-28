#!/bin/bash

TARGET="${1}"

if [[ "${TARGET}" != "" ]]; then

# Get running version using gnmic and jq
echo -n "Getting running version from '${TARGET}'..."
SRL_VERSION=`gnmic -a ${TARGET} --skip-verify get --path /system/information/version -u admin -p NokiaSrl1! -e json_ietf | jq -r '.[].updates[].values[] | split("-")[0]'`
echo "${SRL_VERSION}"

# Checkout YANG models to a temporary directory
WORK_DIR=`mktemp -d`
git clone https://github.com/nokia/srlinux-yang-models.git "${WORK_DIR}"

# Get latest version available
LATEST_VERSION=`cd "${WORK_DIR}" && git tag --sort=committerdate | tail -1`

if [[ "${SRL_VERSION}" != "${LATEST_VERSION}" ]]; then
 cd "${WORK_DIR}" && git diff ${SRL_VERSION} ${LATEST_VERSION}
else
 echo "'${TARGET}' is running the latest version '${LATEST_VERSION}'"
fi

# Cleanup
rm -rf "${WORK_DIR}"

else
echo "Usage: ${0} <target hostname or IP>"
fi

exit 0
