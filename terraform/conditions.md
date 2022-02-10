
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

                  tags = {
                    Name = "Bastion Server for Dev-server"
                  }
                }
