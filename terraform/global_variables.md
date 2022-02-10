## Write global variables

1. Create bucket in aws
2. In terraform file create configs for saving data in bucket

          provider "aws" {
          region = "ca-central-1"
        }

        terraform {
          backend "s3" {
            bucket = "denis-astahov-project-kgb-terraform-state"
            key    = "globalvars/terraform.tfstate"
            region = "us-east-1"
          }
        }

3. create outputs to using them such as variable in future

          output "company_name" {
            value = "ANDESA Soft International"
          }

          output "owner" {
            value = "Denis Astahov"
          }

          output "tags" {
            value = {
              Project    = "Assembly-2020"
              CostCenter = "R&D"
              Country    = "Canada"
            }
            
               
 4. terraform apply



## Reading global variables


        data "terraform_remote_state" "global" {
          backend = "s3"
          config = {
            bucket = "denis-astahov-project-kgb-terraform-state"
            key    = "globalvars/terraform.tfstate"
            region = "us-east-1"
          }
        }

        locals {
          company_name = data.terraform_remote_state.global.outputs.company_name
          owner        = data.terraform_remote_state.global.outputs.owner
          common_tags  = data.terraform_remote_state.global.outputs.tags
        }
