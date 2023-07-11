#!/usr/bin/env bash

set -x -e

SOURCE_FILE=$1
DEST_FILE=$2
SAMPLE_TYPE=$3
INDEX_NAME=$4

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
