#!/bin/bash

# Set up variables
# TODO: Actually, give this a default at /tmp/rawcrd/
if [[ -z "$K8S_CRD_DUMP_PATH" ]]; then
    echo "Please define K8S_CRD_DUMP_PATH env var"
    exit 1
elif [[ ! -d "$K8S_CRD_DUMP_PATH" ]]; then
    mkdir -p $K8S_CRD_DUMP_PATH
fi

# Extract CRDs from cluster
NUM_OF_CRDS=0
while read -r crd
do
    resourceKind=${crd%% *}
    kubectl get crds "$resourceKind" -o yaml > "$K8S_CRD_DUMP_PATH/"$resourceKind".yaml" 2>&1
    let NUM_OF_CRDS++
done < <(kubectl get crds 2>&1 | sed -n '/NAME/,$p' | tail -n +2)

# If no CRDs exist in the cluster, exit
if [ $NUM_OF_CRDS == 0 ]; then
    printf "No CRDs found in the cluster, exiting...\n"
    exit 0
fi

# Create final schemas directory
SCHEMAS_DIR=/var/www/
mkdir -p $SCHEMAS_DIR
cd $SCHEMAS_DIR

# Convert crds to jsonSchema
python3 /usr/bin/openapi2jsonschema.py $K8S_CRD_DUMP_PATH/*.yaml
conversionResult=$?

# Copy and rename files to support kubeval
rm -rf $SCHEMAS_DIR/master-standalone
mkdir -p $SCHEMAS_DIR/master-standalone
cp $SCHEMAS_DIR/*.json $SCHEMAS_DIR/master-standalone
find $SCHEMAS_DIR/master-standalone -name '*json' -exec bash -c ' mv -f $0 ${0/\_/-stable-}' {} \;

GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ $conversionResult == 0 ]; then
    printf "${GREEN}Successfully converted $NUM_OF_CRDS CRDs to JSON schema${NC}\n"
fi

rm -rf $K8S_CRD_DUMP_PATH
