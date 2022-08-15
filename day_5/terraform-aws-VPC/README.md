Terraform Module to provision an VPC with three Public and Private Subnets.

Not intended for production use. It is an example module.

It is just for showing how to create a publish module in Terraform Registry.

Usage:

```hcl

provider "aws" {
  region = "us-east-1"
}

module "myVPC" {
    source = "rknktm/VPC/aws"
}
```