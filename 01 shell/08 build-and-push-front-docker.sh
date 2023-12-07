#!/bin/bash

# shellcheck disable=SC2188
<<'EOF'
Description：Compile a hfins front program to generate an image and push it to choerodon's image repository
Parameter：group_name : Project name for choerodon
Parameter：image_name : Image name
Author: @24Arise
Date: 2023.12.07 12:32:00
Example：sh 08\ build-and-push-front-docker.sh org-hfins-jzjf hfins-front
EOF

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <group_name> <image_name>"
    exit 1
fi

# Get command-line arguments and convert to lowercase
GROUP_NAME="${1,,}" # Convert the first parameter to lowercase
IMAGE_NAME="${2,,}" # Convert the second parameter to lowercase

DOCKER_REGISTRY=registry.choerodon.com.cn
DOCKER_USERNAME="2196"
DOCKER_PASSWORD="TMEGLEc1"

# Install dependencies
echo "=======> Installing dependencies ..."
yarn install

# Transpile common module
echo "=======> Compiling common module ..."
yarn transpile hfins-front-common

# Build dependency modules
echo "=======> Building dependency modules ..."
yarn build:dep-all:prod
yarn build:hb:prod

# Build the entire project
echo "=======> Building the entire project ..."
yarn build:app:prod

# Build hfins module
echo "=======> Building hfins module ..."
HFINS_PACKAGES=$(node ./scripts/get_hfins_packages.js)
yarn build:ms:prod ${HFINS_PACKAGES}

# Build hzero dependency module
echo "=======> Building hzero dependency module ..."
HZERO_PACKAGES=$(node ./scripts/get_hzero_packages.js)
yarn build:ms:prod ${HZERO_PACKAGES}

# Build hippius dependency module
echo "=======> Building hippius dependency module ..."
HIPPIUS_PACKAGES=$(node ./scripts/get_hippius_packages.js)
yarn build:ms:prod ${HIPPIUS_PACKAGES}

# Build htc dependency module
echo "=======> Building htc dependency module ..."
HTC_PACKAGES=$(node ./scripts/get_htc_packages.js)
yarn build:ms:prod ${HTC_PACKAGES}

# Build Docker image
TAG_TIMESTAMP=$(date +"%Y%m%d%H%M%S")
IMAGE_VERSION=${DOCKER_REGISTRY}/${GROUP_NAME}/${IMAGE_NAME}:${TAG_TIMESTAMP}
echo "=======> Current version ${IMAGE_VERSION}"

# Login to Docker registry
echo "=======> Logging in to Docker registry ..."
docker login --username="$DOCKER_USERNAME" --password="$DOCKER_PASSWORD" "$DOCKER_REGISTRY"

# Build Docker image
echo "=======> Building image ${IMAGE_VERSION} ..."
docker build -t "${IMAGE_VERSION}" -f Dockerfile .

# Push Docker image
echo "=======> Pushing image ..."
docker push "${IMAGE_VERSION}"

# Clean up - Delete Docker image
echo "=======> Deleting image ${IMAGE_VERSION} ..."
docker rmi "${IMAGE_VERSION}"
