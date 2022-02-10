
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
                variable "env" {
                  default = "dev"
                }

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
                  instance_type = lookup(var.ec2_size, var.env)   // get value from ec2_size, where key = value of variable env

                  tags = {
                    Name  = "${var.env}-server"
                    Owner = var.env == "prod" ? var.prod_onwer : var.noprod_owner
                  }
                }



# Loops

- works using count 

### Example 

        resource "aws_instance" "newInst" {
          count         = 3
          ami           = "ami-0e472ba40eb589f49"
          instance_type = "t3.large"
          tags = {
            Name = "Name is ${count.index+1}"   // allows to steps by every index of count started from 0 , so we should add 1 
          }
        }

## For each

        resource "aws_iam_user" "users" {
          count = length(var.users_list) // size of list
          name  = element(var.users_list, count.index)
        }
---------------------------------------------------------------        
               
         output "users_name" {
          value = aws_iam_user.users[*].name
        }              


        //Print my Custom output list
        output "created_iam_users_custom" {
          value = [
            for user in aws_iam_user.users :
            "Username: ${user.name} has ARN: ${user.arn}"
          ]
        }

- create map in loop

        //Print My Custom output MAP
        output "created_iam_users_map" {
          value = {
            for user in aws_iam_user.users :
            user.unique_id => user.id // "AIDA4BML4STW22K74HQFF" : "vasya"
          }
        }


# Loop with conditions 


        // Print List of users with name 4 characters ONLY
        output "custom_if_length" {
          value = [
            for x in aws_iam_user.users :  // for user in users
            x.name                        // write name to value
            if length(x.name) == 4        // if length of name == 4 characters
          ]
        }
