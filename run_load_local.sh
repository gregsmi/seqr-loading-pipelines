#!/usr/bin/env bash

set -x -e

BUILD_VERSION=38
FULL_BUILD_VERSION=GRCh38
SAMPLE_TYPE=WGS
INDEX_NAME=gregsmi-test
INPUT_FILE_PATH=GRCh38/prior_to_annotation.vcf.bgz
SOURCE_FILE=/input_vcfs/${INPUT_FILE_PATH}

# REFERENCE_DATA_BUCKET="hail-az://azcpg001sa/reference"
# REFERENCE_DATA_BUCKET="https://azcpg001sa.blob.core.windows.net/reference"
REFERENCE_DATA_BUCKET="abfss://reference@azcpg001sa.dfs.core.windows.net"
REF_HT_PATH="${REFERENCE_DATA_BUCKET}/seqr/v0-1/combined_reference_data_grch${BUILD_VERSION}.ht"
CLINVAR_HT_PATH="${REFERENCE_DATA_BUCKET}/seqr/v0-1/clinvar.${FULL_BUILD_VERSION}.ht"
VEP_CONFIG_PATH="/vep_configs/vep-GRCh38-loftee.json"
GRCH38_TO_GRCH37_REF_PATH="${REFERENCE_DATA_BUCKET}/hail/grch38_to_grch37.over.chain.gz"
docker run -it \
  -v $(pwd)/.data/seqr-reference-data:/seqr-reference-data \
  -v $(pwd)/.data/vep_data:/vep_data \
  -v $(pwd)/.data/input_vcfs:/input_vcfs \
  -v $(pwd)/spark-config:/spark-config \
  pipeline-runner-ms:latest \
  load_data_local.sh $BUILD_VERSION $SAMPLE_TYPE $INDEX_NAME $SOURCE_FILE \
    $REF_HT_PATH $CLINVAR_HT_PATH $VEP_CONFIG_PATH $GRCH38_TO_GRCH37_REF_PATH

