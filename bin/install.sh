#! /bin/bash

# Verify that the required dependencies are installed

command -v docker > /dev/null 2>&1 || { echo >&2 "docker must be installed"; exit 1; }
command -v docker-compose > /dev/null 2>&1 || { echo >&2 "docker-compose must be installed"; exit 1; }

# TODO: Ensure that working directory is at the project root or maybe script
# downloads necessary artifacts?

if [ "$1" == "dev" ]; then
    echo "Starting Jarvis installation for local development.."
    JARVIS_DIR_ROOT="/tmp/jarvis"
    JARVIS_DOCKER_COMPOSE_FILE="$PWD/docker-compose-dev.yml"
elif [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
else
    echo "Starting Jarvis installation.."
    JARVIS_DIR_ROOT="/opt/jarvis"
    JARVIS_DOCKER_COMPOSE_FILE="$PWD/docker-compose.yml"
fi

echo

# Create required directories

JARVIS_DATA_VERSION="20160628"
echo "Creating installation directory"
echo "Installation directory: $JARVIS_DIR_ROOT"
echo "Data model version: $JARVIS_DATA_VERSION"

for target_dir in "LogEntries-$JARVIS_DATA_VERSION" "Tags-$JARVIS_DATA_VERSION" \
    "Images" "Elasticsearch" "Redis"
do
    mkdir -p "$JARVIS_DIR_ROOT/$target_dir"
done

echo

# Copy Elasticsearch mappings to be used by jarvis-api to provision Elasticsearch
#
# REVIEW: Should just hardcode into jarvis-api? Usefulness of having external
# mappings is the ability to test the mapping requests outside of jarvis-api.

mkdir "$JARVIS_DIR_ROOT/Elasticsearch/mappings"
cp $PWD/setup/mappings/* $JARVIS_DIR_ROOT/Elasticsearch/mappings

echo

# Docker-compose up

if [ -e $JARVIS_DOCKER_COMPOSE_FILE ]; then
    echo "Starting up Jarvis containers"
    JARVIS_DIR_ROOT=$JARVIS_DIR_ROOT docker-compose -f $JARVIS_DOCKER_COMPOSE_FILE up -d
else
    echo "Error! Could not find docker-compose file"
    exit 1
fi

# TODO: Should go ahead and install cli too?

echo; echo;
echo "Jarvis installation done!"
