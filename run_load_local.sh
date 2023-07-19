#!/usr/bin/env bash

set -x -e

# Runs the SeqrMTToESTask locally in a docker container.
# Fill in .config/core-sites.xml with necessary Spark ABFS authentication settings/secrets. 
# Download necessary VEP reference data to .data/vep_data.
# Set ELASTIC_SEARCH_PASSWORD environment variable.

BUILD_VERSION=38
SAMPLE_TYPE=WGS
INDEX_NAME=testdata
SOURCE_FILE=abfss://data@azcpg001sa.dfs.core.windows.net/GRCh38/1kg_sample_test.vcf.bgz
DEST_FILE=abfss://data@azcpg001sa.dfs.core.windows.net/GRCh38/1kg_sample_test.mt

# TODO: needs a new config file for local elastic search configuration.
docker run -it \
  -e LUIGI_CONFIG_PATH=/luigi_configs/seqr-load-GRCh${BUILD_VERSION}.toml \
  -e ELASTIC_SEARCH_PASSWORD=${ELASTIC_SEARCH_PASSWORD} \
  -v ./.config/core-site.xml:/spark_configs/core-site.xml \
  -v ./.data/vep_data:/vep_data \
  msseqr01acr.azurecr.io/azure/pipeline-runner:latest \
  luigi --local-scheduler --module seqr_loading SeqrMTToESTask \
      --source-paths $SOURCE_FILE \
      --dest-path $DEST_FILE \
      --sample-type $SAMPLE_TYPE \
      --es-index-min-num-shards 1 \
      --es-index $INDEX_NAME \
      --es-password ${ELASTIC_SEARCH_PASSWORD}
