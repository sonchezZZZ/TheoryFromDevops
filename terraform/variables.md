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
