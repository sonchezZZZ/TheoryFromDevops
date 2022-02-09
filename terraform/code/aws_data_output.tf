provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "working" {}
data "aws_region" "region" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}

output "data" {
  value = data.aws_caller_identity.working.account_id
}

output "data_region_name" {
  value = data.aws_region.region.name
}

output "data_region_descr" {
  value = data.aws_region.region.description
}

output "data_vpc" {
  value = data.aws_vpcs.my_vpcs.ids
}
output "data_prod_vpc" {
  value = data.aws_vpc.prod_vpc.id
}
