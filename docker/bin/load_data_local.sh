#!/usr/bin/env bash

set -x -e

SOURCE_FILE=$1
SAMPLE_TYPE=$2
INDEX_NAME=$3

DEST_FILE="${SOURCE_FILE/.*/}".mt

# additional params loaded from Luigi config files
python3 -m seqr_loading SeqrVCFToMTTask --local-scheduler \
    --source-paths "${SOURCE_FILE}" \
    --dest-path "${DEST_FILE}" \
    --sample-type "${SAMPLE_TYPE}"

# python3 -m seqr_loading SeqrMTToESTask --local-scheduler \
#     --es-host elasticsearch \
#     --es-index-min-num-shards 1 \
#     --es-index "${INDEX_NAME}" \
