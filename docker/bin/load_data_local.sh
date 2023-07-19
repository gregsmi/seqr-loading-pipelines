#!/usr/bin/env bash

set -x -e

SOURCE_FILE=$1
DEST_FILE=$2
SAMPLE_TYPE=$3
INDEX_NAME=$4
CONFIG_PATH=$5

# Point Luigi to the appropriate job config file.
export LUIGI_CONFIG_PATH=${CONFIG_PATH}

# Additional params loaded from Luigi config file.
python3 -m seqr_loading SeqrMTToESTask --local-scheduler \
    --source-paths "${SOURCE_FILE}" \
    --dest-path "${DEST_FILE}" \
    --sample-type "${SAMPLE_TYPE}" \
    --es-index-min-num-shards 1 \
    --es-index "${INDEX_NAME}" \
    --es-password "${ELASTIC_SEARCH_PASSWORD}"
