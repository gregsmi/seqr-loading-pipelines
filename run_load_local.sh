#!/usr/bin/env bash

set -x -e

BUILD_VERSION=38
SAMPLE_TYPE=WGS
INDEX_NAME=gregsmi-test
SOURCE_FILE=abfss://data@azcpg001sa.dfs.core.windows.net/GRCh38/1kg_sample_test.vcf.bgz
DEST_FILE=abfss://data@azcpg001sa.dfs.core.windows.net/GRCh38/1kg_sample_test.mt

# Fill in .config/core-sites.xml with necessary Spark ABFS authentication settings/secrets. 
# Fill in .config/refs.*.cfg with appropriate reference paths.
# Tell Spark and Luigi to use the mounted directory for configuration.
docker run -it \
  -v ./.data/vep_data:/vep_data \
  -v ./.config:/config \
  -e LUIGI_CONFIG_PATH=/config/seqr-loading-GRCh${BUILD_VERSION}.cfg \
  -e SPARK_CONF_DIR=/config \
  pipeline-runner:azure \
  load_data_local.sh $SOURCE_FILE $DEST_FILE $SAMPLE_TYPE $INDEX_NAME

