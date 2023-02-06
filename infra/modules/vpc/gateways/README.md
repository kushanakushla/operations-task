# Gateways module

<br/>

This module handles the provisioning of Internet gateway, NAT gateway and elatic Ips for NAT gateways.

<br/>

## Inputs:

The module requires the following variables to be set, wherever possible these should be set using outputs from other modules, dynamic variables, or read in from *tfvars when deploying.

| Input Variable  | Type | Description | Required | Default | Notes |
|-----------------|------|-------------|----------|---------|-------|
| **public_subnet_ids** | *list* | IDs of public subnets  | **Yes** | None | None |
| **num_az** | *number* | Number of avalibility zone used to deploy subnets  | **Yes** | None | None |
| **vpc_azs** | *list* | List of avalibility zones to deploy subnets | **Yes** | None | None |
| **vpc_name** | *string* | Name of the VPC resource | **Yes** | None | None |
| **vpc_id** | *string* | ID of the VPC | **Yes** | None | None |
| **tags** |  *map* | To provides resource tag | **Yes** | None | None|


## Outputs:
The module provides the following outputs, which can be used to populate variables for use in other modules.

| Output Variable  | Type | Description | Required | Default | Notes |
|------------------|------|-------------|----------|---------|-------|
| **igw_id** | *string* | Returns the id of Intenet gateway deployed | N/A | None | N/A |
| **ngw_id** | *list* | Returns the List of NAT gateway ids deployed | N/A | None | N/A |
| **ngw_ip** | *list* | Returns the List of NAT gateway ips deployed | N/A | None | N/A |

## Usage:

Gateways module can be used as below in your main tf configuration:

#### Gateways module source via local module example:
```
module "gateways" {
  source = "./modules/vpc/gateways"

  vpc_name          = var.vpc_name
  vpc_id            = module.vpc.vpc_id
  vpc_azs           = var.vpc_azs
  num_az            = var.num_az
  public_subnet_ids = module.subnets.public_subnet_ids
  tags              = local.tags
}
```