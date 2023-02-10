#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[0;33m'
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
 
DEPLOYMENT_ENV=$(echo $ENVIRONMENT | tr '[:upper:]' '[:lower:]')
if [ -z "$CREATE_STATE_STACK" ]; then
    echo -e "$YELLOW *** CREATE_STATE_STACK ARGUMENT NOT PROVIDED *** $NC"
    echo -e "$YELLOW *** SKIPPING TF STACK RESOURCES DEPLOYMENT *** $NC"
elif [ $CREATE_STATE_STACK = "True" ]; then
    echo -e "$GREEN *** DEPOLYING/UPDATING TF STATE RESOURCES CF STACK *** $NC"
    aws cloudformation deploy --template-file TFStateResources.yml --stack-name tf-state-resources-stack-${DEPLOYMENT_ENV}
elif [ $CREATE_STATE_STACK = "False" ]; then
    echo -e "$YELLOW *** SKIPPING TF STACK RESOURCES DEPLOYMENT *** $NC"
else
    echo -e "$RED *** INVALID VALUE PROVIDED FOR CREATE_STATE_STACK PARAMETER *** $NC"
    exit
fi

cd infra

echo -e "$GREEN Initializing Terraform Backend for ${DEPLOYMENT_ENV} environment $NC"

terraform init -upgrade -backend-config=backends/${DEPLOYMENT_ENV}/${DEPLOYMENT_ENV}.tfvars

echo -e "$GREEN Executing Terraform Plan for ${DEPLOYMENT_ENV} environment $NC"

terraform plan -var="image_tag=$DEPLOYMENT_VERSION" -var-file=variables/${DEPLOYMENT_ENV}/${DEPLOYMENT_ENV}.tfvars

echo -e "$GREEN Deploying Changes to ${DEPLOYMENT_ENV} environment $NC"

terraform apply -var="image_tag=$DEPLOYMENT_VERSION" -var-file=variables/${DEPLOYMENT_ENV}/${DEPLOYMENT_ENV}.tfvars