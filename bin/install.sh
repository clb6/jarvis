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
    JARVIS_ELASTICSEARCH_URL="localhost:9300"
elif [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
else
    echo "Starting Jarvis installation.."
    JARVIS_DIR_ROOT="/opt/jarvis"
    JARVIS_DOCKER_COMPOSE_FILE="$PWD/docker-compose.yml"
    JARVIS_ELASTICSEARCH_URL="localhost:9200"
fi

echo

# Create required directories

JARVIS_DATA_VERSION="20160628"
echo "Creating installation directory"
echo "Installation directory: $JARVIS_DIR_ROOT"
echo "Data model version: $JARVIS_DATA_VERSION"

for target_dir in "LogEntries-$JARVIS_DATA_VERSION" "Tags-$JARVIS_DATA_VERSION" "Images" "Elasticsearch" "Redis"
do
    mkdir -p "$JARVIS_DIR_ROOT/$target_dir"
done

echo

# Docker-compose up

if [ -e $JARVIS_DOCKER_COMPOSE_FILE ]; then
    echo "Starting up Jarvis containers"
    docker-compose -f $JARVIS_DOCKER_COMPOSE_FILE up -d
else
    echo "Error! Could not find docker-compose file"
    exit 1
fi

## Wait for containers to come up...

SLEEP_TIME=15
echo "Give containers a chance to come up.. $SLEEP_TIME secs"
sleep $SLEEP_TIME # Arbitrary

echo

# Setup Elasticsearch

MAPPINGS_DIR="$PWD/setup/mappings"

if [ -d $MAPPINGS_DIR ]; then
    echo "Setting up Elasticsearch"

    for to_curl in "" \
        "_mapping/tags -d @$MAPPINGS_DIR/mapping_tags.json" \
        "_mapping/logentries -d @$MAPPINGS_DIR/mapping_log_entries.json" \
        "_mapping/events -d @$MAPPINGS_DIR/mapping_events.json"
    do
        CURL_PARAMS="$JARVIS_ELASTICSEARCH_URL/jarvis-$JARVIS_DATA_VERSION/$to_curl"
        CURL_CMD="curl -X PUT $CURL_PARAMS"
        eval $CURL_CMD
    done

    # NOTE! I opted out of using aliases to simplify data migrations
else
    echo "Error! Could not find Elasticsearch mappings"
    exit 1
fi

# TODO: Should go ahead and install cli too?

echo; echo;
echo "Jarvis installation done!"
