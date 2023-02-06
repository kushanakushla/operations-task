# Subnets module

<br/>

This module handles the provisioning of public and private subnets for the VPC.

<br/>

## Inputs:

The module requires the following variables to be set, wherever possible these should be set using outputs from other modules, dynamic variables, or read in from *tfvars when deploying.

| Input Variable  | Type | Description | Required | Default | Notes |
|-----------------|------|-------------|----------|---------|-------|
| **priv_subnets_cidr** | *list* | List of CIDR blocks to deploy private subnets  | **Yes** | None | None |
| **pub_subnets_cidr** | *list* | List of CIDR blocks to deploy public subnets  | **Yes** | None | None |
| **vpc_azs** | *list* | List of avalibility zones to deploy subnets | **Yes** | None | None |
| **vpc_name** | *string* | Name of the VPC resource | **Yes** | None | None |
| **vpc_id** | *string* | ID of the VPC | **Yes** | None | None |
| **tags** |  *map* | To provides resource tag | **Yes** | None | None|


## Outputs:
The module provides the following outputs, which can be used to populate variables for use in other modules.

| Output Variable  | Type | Description | Required | Default | Notes |
|------------------|------|-------------|----------|---------|-------|
| **public_subnet_cidrs** | *list* | Returns the List of public subnet cidrs deployed | N/A | None | N/A |
| **public_subnet_ids** | *list* | Returns the List of public subnet ids deployed | N/A | None | N/A |
| **private_subnet_cidrs** | *list* | Returns the List of private subnet cidrs deployed | N/A | None | N/A |
| **private_subnet_ids** | *list* | Returns the List of private subnet ids deployed | N/A | None | N/A |

## Usage:

Subnets module can be used as below in your main tf configuration:

#### Subnets module source via local module example:
```
module "subnets" {
  source = "./modules/vpc/subnets"

  region            = var.region
  vpc_azs           = var.vpc_azs
  vpc_id            = module.vpc.vpc_id
  vpc_name          = var.vpc_name
  priv_subnets_cidr = var.priv_subnets_cidr
  pub_subnets_cidr  = var.pub_subnets_cidr
  tags              = local.tags
}
```