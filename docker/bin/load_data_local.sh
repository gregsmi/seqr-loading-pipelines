#!/usr/bin/env bash

set -x -e

BUILD_VERSION=$1
SAMPLE_TYPE=$2
INDEX_NAME=$3
SOURCE_FILE=$4
REF_HT_PATH=$5
CLINVAR_HT_PATH=$6
VEP_CONFIG_PATH=$7
GRCH38_TO_GRCH37_REF_PATH=$8

DEST_FILE="${SOURCE_FILE/.*/}".mt

python3 -m seqr_loading SeqrVCFToMTTask --local-scheduler \
    --source-paths "${SOURCE_FILE}" \
    --dest-path "${DEST_FILE}" \
    --genome-version "${BUILD_VERSION}" \
    --sample-type "${SAMPLE_TYPE}" \
    --reference-ht-path "${REF_HT_PATH}" \
    --clinvar-ht-path "${CLINVAR_HT_PATH}" \
    --vep-config-json-path "${VEP_CONFIG_PATH}" \
    --grch38-to-grch37-ref-chain "${GRCH38_TO_GRCH37_REF_PATH}" \
    --vep-runner "DUMMY"

# python3 -m seqr_loading SeqrMTToESTask --local-scheduler \
#     --reference-ht-path "/seqr-reference-data/${FULL_BUILD_VERSION}/combined_reference_data_grch${BUILD_VERSION}.ht" \
#     --clinvar-ht-path "/seqr-reference-data/${FULL_BUILD_VERSION}/clinvar.${FULL_BUILD_VERSION}.ht" \
#     --vep-config-json-path "/vep_configs/vep-${FULL_BUILD_VERSION}-loftee.json" \
#     --es-host elasticsearch \
#     --es-index-min-num-shards 1 \
#     --sample-type "${SAMPLE_TYPE}" \
#     --es-index "${INDEX_NAME}" \
#     --genome-version "${BUILD_VERSION}" \
#     --source-paths "${SOURCE_FILE}" \
#     --dest-path "${DEST_FILE}"
