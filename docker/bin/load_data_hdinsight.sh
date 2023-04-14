#!/usr/bin/env bash

set -x -e

BUILD_VERSION=$1
SAMPLE_TYPE=$2
INDEX_NAME=$3
STORAGE_ACCOUNT=$4
RESOURCE_GROUP=$5
INPUT_FILE_PATH=$6 # has a leading "/"

case ${BUILD_VERSION} in
  38)
    FULL_BUILD_VERSION=GRCh38
    ;;
  37)
    FULL_BUILD_VERSION=GRCh37
    ;;
  *)
    echo "Invalid build '${BUILD_VERSION}', should be 37 or 38"
    exit 1
esac

SOURCE_FILE="hail-az://${STORAGE_ACCOUNT}${INPUT_FILE_PATH}"
DEST_FILE="${SOURCE_FILE/.*/}".mt
# TODO needs a canonical well-known location that makes more sense
REFERENCE_DATA_BUCKET="hail-az://${STORAGE_ACCOUNT}/reference/seqr/v0-1"
LOFTEE_PATH="https://${STORAGE_ACCOUNT}.blob.core.windows.net/reference/vep/105.0/loftee"
HTTP_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c22)

# cd /seqr-loading-pipelines/luigi_pipeline
cd luigi_pipeline

# TODO GRS Create a pyfiles zip archive and copy it to the loftee location 
# so it will get copied into hdinsight space, where install-vep-libs.sh
# will put in in the python path. This is obviously a terrible solution.
zip -r ../pyfiles.zip lib
cd ..
zip -r pyfiles.zip hail_scripts
az storage copy --source 'pyfiles.zip' --destination ${LOFTEE_PATH}/pyfiles.zip
cd luigi_pipeline

# create hdinsight cluster
# --vep-config-uri default: hail/python/hailtop/hailctl/hdinsight/resources/vep-{args.vep}.json
# --install-vep-uri default: github/hail-is/hail/{v}/hail/python/hailtop/hailctl/hdinsight/resources/install-vep.sh
hailctl hdinsight start \
    --location eastus \
    --num-workers 2 \
    --http-password ${HTTP_PASSWORD} \
    --vep ${FULL_BUILD_VERSION} \
    --vep-loftee-uri ${LOFTEE_PATH} \
    --vep-homo-sapiens-uri https://${STORAGE_ACCOUNT}.blob.core.windows.net/reference/vep/105.0/vep/homo_sapiens/105_GRCh38 \
    --install-hail-uri https://raw.githubusercontent.com/gregsmi/hail/bug/hdinsight-start/hail/python/hailtop/hailctl/hdinsight/resources/install-hail.sh \
    --install-vep-uri https://raw.githubusercontent.com/gregsmi/seqr-loading-pipelines/feature/hdinsight-enable/docker/bin/install_vep_libs.sh \
    seqr-loading-cluster ${STORAGE_ACCOUNT} ${RESOURCE_GROUP}

# submit annotation job to hdinsight cluster
hailctl hdinsight submit seqr-loading-cluster ${STORAGE_ACCOUNT} ${HTTP_PASSWORD} \
    seqr_loading.py \
    SeqrVCFToMTTask --local-scheduler \
         --source-paths "${SOURCE_FILE}" \
         --dest-path "${DEST_FILE}" \
         --genome-version "${BUILD_VERSION}" \
         --sample-type "${SAMPLE_TYPE}" \
         --vep-config-json-path "${REFERENCE_DATA_BUCKET}/vep-${FULL_BUILD_VERSION}-loftee-dataproc.json" \
         --reference-ht-path  "${REFERENCE_DATA_BUCKET}/combined_reference_data_grch${BUILD_VERSION}.ht" \
         --clinvar-ht-path "${REFERENCE_DATA_BUCKET}/clinvar.${FULL_BUILD_VERSION}.ht"

# JOB_ID=$(gcloud dataproc jobs list)    # run this to get the dataproc job id
# gcloud dataproc jobs wait "${JOB_ID}"  # view jobs logs and wait for the job to complete

# # load the annotated dataset into your local elasticsearch instance
# python3 -m seqr_loading SeqrMTToESTask --local-scheduler \
#      --dest-path "${DEST_FILE}" \
#      --es-host elasticsearch  \
#      --es-index "${INDEX_NAME}"
