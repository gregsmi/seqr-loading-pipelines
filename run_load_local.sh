#!/usr/bin/env bash

set -x -e

BUILD_VERSION=38
SAMPLE_TYPE=WGS
INDEX_NAME=gregsmi-test
SOURCE_FILE=/input_vcfs/GRCh38/prior_to_annotation.vcf.bgz

# Fill in .config/core-sites.xml with necessary Spark ABFS authentication settings/secrets. 
# Fill in .config/refs.*.cfg with appropriate reference paths.
# Tell Spark and Luigi to use the mounted directory for configuration.
docker run -it \
  -v ./.data/seqr-reference-data:/seqr-reference-data \
  -v ./.data/vep_data:/vep_data \
  -v ./.data/input_vcfs:/input_vcfs \
  -v ./.config:/config \
  -e LUIGI_CONFIG_PATH=/config/refs.${BUILD_VERSION}.cfg \
  -e SPARK_CONF_DIR=/config \
  pipeline-runner-ms:latest \
  load_data_local.sh $SOURCE_FILE $SAMPLE_TYPE $INDEX_NAME

