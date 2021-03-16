#!/bin/bash
# Script to open the epitech moulinette Docker container
# Author Pol Bachelin

setup_colors() {
    if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
        NOCOLOR='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
          else
    NOCOLOR='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
    fi
}

print() {
    echo >&2 -e "${1-}"
}

usage() {
    cat <<EOF
Usage: ./epitech_docker [-d] [-h]

This script will open the epitech moulinette Docker container in the directory you have choosen
In order to test different commands

-h Prints help and exits
-d To specify directory
EOF
    exit
}

die() {
    msg=$1
    print "$msg"
    exit
}

parse_params() {
    param=''
    while :; do
        case "${1-}" in
        -h)
        usage
        ;;
        -d)
        param="${2-}"
        shift
        ;;
        *)
        break
        ;;
        esac
        shift
    done

    args=("$@")
    return 0
}

parse_params "$@"
setup_colors

if (( $EUID != 0 )); then
    print "${RED}Please run as root${NOCOLOR}"
    exit
fi

if [[ "$(systemctl is-active docker)" = "inactive" ]]; then
    print "${CYAN}Starting docker${NOCOLOR}"
    sudo systemctl start docker
    print "${CYAN}Docker has been started...${NOCOLOR}"
fi

if [[ "${param:$i:1}" != '/' ]]; then
    "${param:$i:1}" = '/'
fi

print "${ORANGE}Pulling epitech container${NOCOLOR}"
sudo docker pull epitechcontent/epitest-docker
print "${BLUE}Launching container in directory ${param}${NOCOLOR}"
docker run -it --rm -v ${param}:/home/project -w /home/project epitechcontent/epitest-docker /bin/bash
