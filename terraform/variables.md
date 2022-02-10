# Variables 


- simple variable, that need write with terraform plan


       variable "region" {
          description = "Enter region"            // placeholder
          default = "us-east-1"                   // default value  and not let write in console
      }
        
        
        resource "aws_eip"  "elastic-ip"{
              instance = aws_instance.my_server.id

              tags = {
                Region = var.region)

            }
        }

## Add to variable list element

               tags = merge(var.common_tags, {Name = "Server IP"})
               
               // variable "common_tags" {
                       type = map
                       description = " tags fro all resources"
                       default = {
                         Owner = "Sofiia Cherednychenko"
                         Project = "Sonchezz_Environment"
                       }
                     }

## In some field add element from variable(list)

                   tags = {
                   Name = "${var.common_tags["Environment"]} some individual text"
                   }


## For change variable default value when apply or plan

                    terraform plan -var="region=us-west-1"
                    
                     terraform plan -var="region=us-west-1"  -var="instance_type=t3.micro "

or 

                    export TF_VAR_region=us_west-2 
                    export TF_VAR_instance_type=t3.micro
                    
                    // check = echo $TF_VAR_region
                    
                    terraform apply

or create autofills file

             filename : terraform.tfvars   // dev.auto.tfvars   // prod.auto.tfvars
             
             Inside file : 
             
             region = "us-east-1"
             detail_monitoring = false
             ...

- if several tfvar files in folder  `` terraform plan -var-file="prod.auto.tfvars" ``

 
## Concat two variables 

                     full_project_name = "${var.env}.${var.project_name}"
                     owner = "${var.owner} owner of ${var.project_name}"
                     
## Local variables

              locals {
                full_project_name = "${var.env}.${var.project_name}"
              }


              resource "aws_eip" "my_static_ip" {
                instance = aws_instance.my_Ubuntu.id
                tags ={
                  Name = "Static IP"
                  Owner = local.full_project_name
                }
              }

### Local variable from data

                region = data.aws_region.regionAws
                
### Local variable from data as list

        az_list = join(",", data.aws_availability_zones.availabilities.names)


## Actions with variables

- 
