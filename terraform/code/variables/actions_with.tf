provider "aws" { // regin where to create instances
}

variable "users_list" {
  default = ["Katya", "Masha", "Kolya"]
}


resource "aws_iam_user" "user1" {
  Name = "PersFormTerraform"
}



resource "aws_iam_user" "users" {
  count = length(var.users_list) // size of list 
  name  = element(var.users_list, count.index)     // for every user use element with number by count step
}


resource "aws_instance" "newInst" {
  count         = 3
  ami           = "ami-0e472ba40eb589f49"
  instance_type = "t3.large"
  tags = { 
    Name = "Number is ${count.index}"     // from every index count gets 
  }
}
