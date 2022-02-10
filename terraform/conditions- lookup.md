
# Conditions


- /Тернарный оператор 

        ``` instance_type = var.env == "prod" ? "t2.large":"t2.micro" ```
        
- Знаки  || , && , !, == , !=        



## Example: 

                provider "aws" {
                }

                variabe "env" {
                  default = "dev"
                }
                resource "aws_instance" "my_Amazon" {
                  ami           = "ami-0e472ba40eb589f49"
                  instance_type = var.env == "prod" ? "t3.large" : "t2.micro"

                }


## Condition  create instance or no

                // Create Bastion ONLY for if "dev" environment
                resource "aws_instance" "my_dev_bastion" {
                  count         = var.env == "dev" ? 1 : 0
                  ami           = "ami-03a71cec707bfc3d7"
                  instance_type = "t2.micro"
                }        

# Lookup

- variable = map ``` variable "ec2_size" {...} ```
- команда `` instance_type = lookup(var.ec2_size "prod")``
-      
     
## Example


                 variable "ec2_size" {
                      default = {
                         "prod"    = "t3.medium"
                         "dev"     = "t3.micro"
                         "staging" = "t2.small"
                    }
                 }                        
                        
                // Use of LOOKUP
                resource "aws_instance" "my_webserver2" {
                  ami           = "ami-03a71cec707bfc3d7"
                  instance_type = lookup(var.ec2_size, var.env)

                  tags = {
                    Name  = "${var.env}-server"
                    Owner = var.env == "prod" ? var.prod_onwer : var.noprod_owner
                  }
                }

