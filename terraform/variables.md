# Variables 


- simple variable, that need write with terraform plan


       variable "region" {
          description = "Enter region"            // placeholder
          default = "us-east-1"                   // default value
      }
        
        
        resource "aws_eip"  "elastic-ip"{
              instance = aws_instance.my_server.id

              tags = {
                Region = var.region)

            }
        }
