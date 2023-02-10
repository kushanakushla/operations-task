#!/bin/bash


result=$(aws ecr describe-images --output text --repository-name $1 --image-ids imageTag="$2" --query "imageDetails[].imageDigest" 2>&1)
if [ $? -eq 0  ]; then
repository_url=$(echo $result | jq -r '.repositories[0].repositoryUri')
echo -n "{\"success\":\"true\", \"repository_url\":\"$image_digest\", \"name\":\"$1\"}"
else
error_message=$(echo $result | jq -R -s -c '.')
echo -n "{\"success\":\"false\"}"
fi