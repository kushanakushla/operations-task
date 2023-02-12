### This is a template file describing the configuration required for define a new terraform backend

bucket         = s3 bucket to store the terraform state.
key            = specific key in the state bucket to store the terraform state.
dynamodb_table = dynamdodb table to handle tf state lock. 
region         = region of the deployment.
