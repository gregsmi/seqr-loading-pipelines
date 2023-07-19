#!/usr/bin/env bash

set -x -e

SOURCE_FILE=$1
DEST_FILE=$2
BUILD_VERSION=$3
SAMPLE_TYPE=$4
INDEX_NAME=$5

# Point Luigi to the correct mounted config file for default args.
export LUIGI_CONFIG_PATH=/luigi_configs/seqr-loading-GRCh${BUILD_VERSION}.toml

# Additional params loaded from Luigi config file.
python3 -m seqr_loading SeqrMTToESTask --local-scheduler \
    --source-paths "${SOURCE_FILE}" \
    --dest-path "${DEST_FILE}" \
    --sample-type "${SAMPLE_TYPE}" \
    --es-index-min-num-shards 1 \
    --es-index "${INDEX_NAME}" \
    --es-password "${ELASTIC_SEARCH_PASSWORD}"
