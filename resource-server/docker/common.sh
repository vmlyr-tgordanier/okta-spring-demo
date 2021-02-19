#!/bin/bash
#exit on any error
set -e

# NOTE: The paths specified below must be relative to the location
# of this script, when executed.  This is captured in the GIT_FOLDER
# variable and must be altered if this directory structure is altered.

# the docker network here must match the one specified in docker-compose.yml
DOCKER_NETWORK='okta'
GIT_FOLDER=..
RED=1
GREEN=2
YELLOW=3

# Simple helper method to produce colored output
print_c() {
    if [ -x "$(command -v tput)" ] ; then
        tput setaf $1; echo "$2"; tput sgr0
    else
        echo $2
    fi
}

quit_w_error() {
    echo ' '
    print_c ${RED} "$1"
    sleep 1
    echo ' '
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
}

# check if user is logged in as root.  if not, have them authenticate here
# so they get a friendlier message explaining why they are being prompted
# to enter a password.
check_is_root() {
    if [ ! `whoami` = root ] ; then 
        print_c ${YELLOW} 'Root privledges are required to execute portions of this script.'
        print_c ${YELLOW} 'You may be propmpted for the password of the root user.'  
        sudo echo ''
    fi
}

create_docker_network_if_not_exists() {
    if ! sudo docker network inspect "${DOCKER_NETWORK}" > /dev/null ; then
        if ! sudo docker network create -d bridge ${DOCKER_NETWORK} > /dev/null; then
            quit_w_error "Could not create docker network ${DOCKER_NETWORK}"
        fi
        print_c ${GREEN} "Docker network ${DOCKER_NETWORK} created"
    fi
}

move_wsl2_bad_config_file() {
    if grep -i -q Microsoft /proc/version; then
        print_c ${GREEN} "WSL environment detected"
        if [ -f "$HOME/.docker/config.json" ] ; then
            current_time=$(date "+%Y.%m.%d-%H.%M.%S")
            print_c ${RED} "WARNING!  A known bug with WSL makes Docker Compose fail to run if credStore is specified"
            print_c ${RED} "in your ~/.docker/config.json file.  For this reason, your config file has been renamed."
            mv "$HOME/.docker/config.json" "$HOME/.docker/config.json.${current_time}" 
        fi
    fi
}

start_docker_container() {
    move_wsl2_bad_config_file
    create_docker_network_if_not_exists
    # start docker container if not already running.  if exited, remove and recompose
    if [ ! "$(sudo docker ps -q -f name=$1)" ] ; then
        print_c ${GREEN} "Starting Docker container: $1"
        if [ "$(sudo docker ps -aq -f status=exited -f name=$1)" ] ; then
            sudo docker rm $1
        fi
        sudo docker-compose up -d
    else
        print_c ${GREEN} "DockerCcontainer $1 already running."
    fi
    echo ' '
}