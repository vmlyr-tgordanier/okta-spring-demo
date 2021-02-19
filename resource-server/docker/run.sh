#!/bin/bash

DOCKER_CONTAINER_NAME=docker_okta_api_server_1
source common.sh

check_is_root
start_docker_container ${DOCKER_CONTAINER_NAME}

print_c ${GREEN} 'Cleaning out files in container'
if ! sudo docker exec -it $DOCKER_CONTAINER_NAME /bin/bash -c "rm -Rf /var/opt/java/src" ; then
    quit_w_error 'Could not clean folders'
fi

print_c ${GREEN} 'Copying files into container'
if ! sudo docker cp "${GIT_FOLDER}" "$DOCKER_CONTAINER_NAME:/var/opt/java/src" ; then
    quit_w_error 'Could not copy source files'
fi

print_c ${GREEN} 'Running Gradle'
sudo docker exec -it $DOCKER_CONTAINER_NAME /bin/bash -c "export GRADLE_USER_HOME=~/.gradle && cd /var/opt/java/src && ./gradlew bootRun"
