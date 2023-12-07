#!/bin/bash

# shellcheck disable=SC2188
<<'EOF'
Description：Compile a java program to generate an image and push it to choerodon's image repository
Parameter：group_name : Project name for choerodon
Parameter：image_name : Image name
Author: @24Arise
Date: 2023.12.07 12:32:00
Example：sh 07\ build-and-push-java-docker.sh org-hfins-jzjf hfins
EOF

set -e

# Get command-line arguments and convert to lowercase
GROUP_NAME="${1,,}" # Convert the first parameter to lowercase
IMAGE_NAME="${2,,}" # Convert the second parameter to lowercase

if [ -z "$GROUP_NAME" ] || [ -z "$IMAGE_NAME" ]; then
    echo "Usage: $0 <group_name> <image_name>"
    exit 1
fi

DOCKER_REGISTRY=registry.choerodon.com.cn
DOCKER_USERNAME="2196"
DOCKER_PASSWORD="TMEGLEc1"

build_jar() {
    echo "=======> Building jar ..."
    mvn clean package -U -Dmaven.javadoc.skip=true
}

copy_jar() {
    echo "=======> Copying jar ..."
    cp ./target/app.jar ./app.jar
}

login_docker_registry() {
    echo "=======> Logging in to Docker registry ..."
    docker login --username="$DOCKER_USERNAME" --password="$DOCKER_PASSWORD" "$DOCKER_REGISTRY"
}

build_docker_image() {
    TAG_TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    IMAGE_VERSION="${DOCKER_REGISTRY}/${GROUP_NAME}/${IMAGE_NAME}:${TAG_TIMESTAMP}"

    echo "=======> Building image ${IMAGE_VERSION} ..."
    docker build -t "${IMAGE_VERSION}" -f Dockerfile .
}

push_docker_image() {
    echo "=======> Pushing image ${IMAGE_VERSION} ..."
    docker push "${IMAGE_VERSION}"
}

cleanup() {
    echo "=======> Cleaning up ..."
    rm -rf ./app.jar
    docker rmi "${IMAGE_VERSION}"
}

main() {
    build_jar
    copy_jar
    login_docker_registry
    build_docker_image
    push_docker_image
    cleanup
}

main
