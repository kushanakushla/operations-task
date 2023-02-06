# Virtual Private Cloud (VPC) module
<br/>
This module handles the provisioning of a Virtual Private Cloud (VPC).

<br/>

## Inputs:

The module requires the following variables to be set, wherever possible these should be set using outputs from other modules, dynamic variables, or read in from *tfvars when deploying.

| Input Variable  | Type | Description | Required | Default | Notes |
|-----------------|------|-------------|----------|---------|-------|
| **vpc_cidr** | *string* | IP CIDR block for provision VPC  | **Yes** | None | None |
| **vpc_name** | *string* | Name for VPC resource | **Yes** | None | None |
| **tag** |  *map* | To provides resource tag | **Yes** | None | None|



## Outputs:
The module provides the following outputs, which can be used to populate variables for use in other modules.

| Output Variable  | Type | Description | Required | Default | Notes |
|------------------|------|-------------|----------|---------|-------|
| **vpc_id** | *string* | Returns the ID of the VPC deployed | N/A | None | N/A |



## Usage:

VPC module can be used as below in your main tf configuration:

#### VPC module source via local module example:
```
module "vpc" {
  source = "./modules/vpc/vpc"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  tags     = local.tags
}
```