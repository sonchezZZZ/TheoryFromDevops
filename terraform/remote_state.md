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
