#!/bin/bash
DOCKER_CONTAINER_NAME=docker_okta_app_server_1

source common.sh

check_is_root
start_docker_container ${DOCKER_CONTAINER_NAME}

print_c ${GREEN} 'Cleaning out files in container'
if ! sudo docker exec -it $DOCKER_CONTAINER_NAME /bin/bash -c "rm -Rf ~/.gradle; rm -Rf /var/opt/java/src" ; then
    quit_w_error 'Could not clean folders'
fi

print_c ${GREEN} 'Copying files into container'
if ! sudo docker cp "${GIT_FOLDER}" "$DOCKER_CONTAINER_NAME:/var/opt/java/src" ; then
    quit_w_error 'Could not copy source files'
fi

print_c ${GREEN} 'Creating gradle folder in container'
if ! sudo docker exec -it $DOCKER_CONTAINER_NAME /bin/bash -c "mkdir ~/.gradle" ; then
    quit_w_error 'Could not copy source files'
fi

print_c ${GREEN} "Docker setup completed"