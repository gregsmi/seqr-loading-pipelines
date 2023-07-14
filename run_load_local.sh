#!/usr/bin/env bash

set -x -e

BUILD_VERSION=38
SAMPLE_TYPE=WGS
INDEX_NAME=testdata
SOURCE_FILE=abfss://data@azcpg001sa.dfs.core.windows.net/GRCh38/1kg_sample_test.vcf.bgz
DEST_FILE=abfss://data@azcpg001sa.dfs.core.windows.net/GRCh38/1kg_sample_test.mt

# Fill in .config/core-sites.xml with necessary Spark ABFS authentication settings/secrets. 
# Download necessary VEP reference data to .data/vep_data.

docker run -it \
  -v ./.config/core-site.xml:/spark_configs/core-site.xml \
  -v ./.data/vep_data:/vep_data \
  pipeline-runner:azure \
  load_data_local.sh $SOURCE_FILE $DEST_FILE $BUILD_VERSION $SAMPLE_TYPE $INDEX_NAME
