# Remote State for Terraform files 



1. Create S3 bucket
2. Get region and name
3. in tf file:

        terraform {
          backend "s3" {
            bucket = "bucket_name"
            key    = "dev/network/terraform.tfstate"
            region = "bucket_region"
          }
        }
        
4. After apply file terraform.tfstate will be saved in bucket        



## Get data from tfstate

                data "terraform_remote_state" "network" {
                  backend = "s3"
                  config = {
                    bucket = "denis-astahov-project-kgb-terraform-state" // Bucket from where to GET Terraform State
                    key    = "dev/network/terraform.tfstate"             // Object name in the bucket to GET Terraform state
                    region = "us-east-1"                                 // Region where bycket created
                  }
                }
                
-------------------------------------------------------------------------------------------------   


                resource "aws_security_group" "webserver" {
                  name = "WebServer Security Group"
                  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
                  ...
                } 
