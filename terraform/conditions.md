
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
