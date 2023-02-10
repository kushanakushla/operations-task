#!/bin/bash

#Set Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[0;33m'

# fetch argument parameters
for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)

   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"

   export "$KEY"="$VALUE"
done

if [ -z "$ENVIRONMENT" ] || [ -z "$DEPLOYMENT_VERSION" ]
then
    echo -e "$RED *** IDENTIFIED REQUIRED PARAMETERS 'ENVIRONMENT' or 'DEPLOYMENT_VERSION' NOT PROVIDED *** $NC"
    exit
fi
 
# deploy tf state resources cloudformation stack
DEPLOYMENT_ENV=$(echo $ENVIRONMENT | tr '[:upper:]' '[:lower:]')

cd infra

# initialize terraform
echo -e "$GREEN Initializing Terraform Backend for ${DEPLOYMENT_ENV} environment $NC"

terraform init -upgrade -backend-config=backends/${DEPLOYMENT_ENV}/${DEPLOYMENT_ENV}.tfvars

# run terraform plan
echo -e "$GREEN Executing Terraform Plan for ${DEPLOYMENT_ENV} environment $NC"

terraform plan -var="image_tag=$DEPLOYMENT_VERSION" -var-file=variables/${DEPLOYMENT_ENV}/${DEPLOYMENT_ENV}.tfvars

# apply terraform plan
echo -e "$GREEN Destroying ${DEPLOYMENT_ENV} environment $NC"

terraform apply -var="image_tag=$DEPLOYMENT_VERSION" -var-file=variables/${DEPLOYMENT_ENV}/${DEPLOYMENT_ENV}.tfvars

cd ../

# delete tf state resources cloudformation stack
if [ -z "$DESTROY_STATE_STACK" ]; then
    echo -e "$YELLOW *** DESTROY_STATE_STACK ARGUMENT NOT PROVIDED *** $NC"
    echo -e "$YELLOW *** SKIPPING TF STACK RESOURCES DELETION *** $NC"
elif [ $DESTROY_STATE_STACK = "True" ]; then
    echo -e "$GREEN *** DELETING TF STATE RESOURCES CF STACK *** $NC"
    aws cloudformation delete-stack --stack-name tf-state-resources-stack-${DEPLOYMENT_ENV}
elif [ $DESTROY_STATE_STACK = "False" ]; then
    echo -e "$YELLOW *** SKIPPING TF STACK RESOURCES DELETIONT *** $NC"
else
    echo -e "$RED *** INVALID VALUE PROVIDED FOR DESTROY_STATE_STACK PARAMETER *** $NC"
    exit
fi
