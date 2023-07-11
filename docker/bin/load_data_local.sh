#!/usr/bin/env bash

set -x -e

SOURCE_FILE=$1
DEST_FILE=$2
BUILD_VERSION=$3
SAMPLE_TYPE=$4
INDEX_NAME=$5

# Point Luigi to the correct mounted config file for default args.
export LUIGI_CONFIG_PATH=/luigi_configs/seqr-loading-GRCh${BUILD_VERSION}.cfg

# additional params loaded from Luigi config files
python3 -m seqr_loading SeqrVCFToMTTask --local-scheduler \
    --source-paths "${SOURCE_FILE}" \
    --dest-path "${DEST_FILE}" \
    --sample-type "${SAMPLE_TYPE}"

# python3 -m seqr_loading SeqrMTToESTask --local-scheduler \
#     --dest-path "${DEST_FILE}" \
#     --es-host elasticsearch \
#     --es-index-min-num-shards 1 \
#     --es-index "${INDEX_NAME}"
