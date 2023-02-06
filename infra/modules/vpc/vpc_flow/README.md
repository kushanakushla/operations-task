# Vpc_flow module

<br/>

This module handles the provisioning of IAM roles, policies and cloudwatch log groups to enable VPC flowlogs.

## Inputs:

The module requires the following variables to be set, wherever possible these should be set using outputs from other modules, dynamic variables, or read in from *tfvars when deploying.

| Input Variable  | Type | Description | Required | Default | Notes |
|-----------------|------|-------------|----------|---------|-------|
| **vpc_flow_iam_set** | *bool* | Set this to true for enable create IAM roles and policies required to enable VPC flow logs  | **Yes** | True | None |
| **vpc_name** | *string* | Name of the VPC resource | **Yes** | None | None |
| **vpc_id** | *string* | ID of the VPC | **Yes** | None | None |
| **tags** |  *map* | To provides resource tags | **Yes** | None | None|


## Outputs:
Currently no outputs available for this module

## Usage:

Vpc_flow module can be used as below in your main tf configuration:

#### Vpc_flow module source via local module example:
```
module "vpc_flow_logs" {
  source = "./modules/vpc/vpc_flow"

  vpc_id           = module.vpc.vpc_id
  vpc_flow_iam_set = var.vpc_flow_iam_set
  vpc_name         = var.vpc_name
  tags             = local.tags
}
```