# Routes module

<br/>

This module handles the provisioning of Route tables for public, private subnets and their association with the subnets.
<br/>

## Inputs:

The module requires the following variables to be set, wherever possible these should be set using outputs from other modules, dynamic variables, or read in from *tfvars when deploying.

| Input Variable  | Type | Description | Required | Default | Notes |
|-----------------|------|-------------|----------|---------|-------|
| **public_subnet_ids** | *list* | IDs of public subnets  | **Yes** | None | None |
| **private_subnet_ids** | *list* | IDs of private subnets  | **Yes** | None | None |
| **num_az** | *number* | Number of avalibility zone used to deploy subnets  | **Yes** | None | None |
| **vpc_azs** | *list* | List of avalibility zones to deploy subnets | **Yes** | None | None |
| **vpc_name** | *string* | Name of the VPC resource | **Yes** | None | None |
| **vpc_id** | *string* | ID of the VPC | **Yes** | None | None |
| **igw_id** | *string* | ID of the Internet Gateway | **Yes** | None | None |
| **ngw_id** | *list* | List of NAT gateway IDs | **Yes** | None | None |
| **tags** |  *map* | To provides resource tag | **Yes** | None | None|


## Outputs:
Currently no outputs available for this module

## Usage:

Routes module can be used as below in your main tf configuration:

#### Routes module source via local module example:
```
module "routes" {
  source = "./modules/vpc/routes"

  vpc_id             = module.vpc.vpc_id
  vpc_name           = var.vpc_name
  vpc_azs            = var.vpc_azs
  igw_id             = module.gateways.igw_id
  ngw_id             = module.gateways.ngw_id
  num_az             = var.num_az
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  tags               = local.tags
}
```