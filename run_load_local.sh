#!/usr/bin/env bash

set -x -e

BUILD_VERSION=38
SAMPLE_TYPE=WGS
INDEX_NAME=gregsmi-test
SOURCE_FILE=/input_vcfs/GRCh38/prior_to_annotation.vcf.bgz

# Fill in /run-config/core-sites.xml with necessary Spark ABFS authentication settings/secrets. 
# Fill in /run-config/refs.*.cfg with appropriate reference paths.
# Tell Spark and Luigi to use the mounted directory for configuration.
docker run -it \
  -v $(pwd)/.data/seqr-reference-data:/seqr-reference-data \
  -v $(pwd)/.data/vep_data:/vep_data \
  -v $(pwd)/.data/input_vcfs:/input_vcfs \
  -v $(pwd)/run-config:/run-config \
  -e LUIGI_CONFIG_PATH=/run-config/refs.${BUILD_VERSION}.cfg \
  -e SPARK_CONF_DIR=/run-config \
  pipeline-runner-ms:latest \
  load_data_local.sh $SAMPLE_TYPE $INDEX_NAME $SOURCE_FILE

