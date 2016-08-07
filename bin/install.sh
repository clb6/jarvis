#! /bin/bash

# Verify that the required dependencies are installed

command -v docker > /dev/null 2>&1 || { echo >&2 "docker must be installed"; exit 1; }
command -v docker-compose > /dev/null 2>&1 || { echo >&2 "docker-compose must be installed"; exit 1; }

if [ "$1" == "dev" ]; then
    echo "Starting Jarvis installation for local development.."
    JARVIS_DIR_ROOT="/tmp/jarvis"
elif [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
else
    echo "Starting Jarvis installation.."
    JARVIS_DIR_ROOT="/opt/jarvis"
fi

# Create required directories

JARVIS_DATA_VERSION="20160628"
echo "Installation directory: $JARVIS_DIR_ROOT"
echo "Data model version: $JARVIS_DATA_VERSION"

for target_dir in "LogEntries-$JARVIS_DATA_VERSION" "Tags-$JARVIS_DATA_VERSION" "Images" "Elasticsearch" "Redis"
do
    mkdir -p "$JARVIS_DIR_ROOT/$target_dir"
done

# TODO: Compose up
