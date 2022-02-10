provider "aws" {
  access_key = "****"                     // from IAM user
  secret_key = "****" // from IAM user
  region     = "us-east-1"                                // regin where to create instances
}

resource "aws_instance" "my_Ubuntu" {     // aws instance with name my_Ubuntu
  count         = 1                       // count of created servers with such parameters
  ami           = "ami-0e472ba40eb589f49" // server image  from amazon
  instance_type = "t2.micro"              // instance type from amazon
  tags = {
    Name = "My Ubuntu"
  }
}

resource "aws_instance" "my_Amazon" {
  ami           = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"

  tags = {
    Name    = "My amazon server"
    Owner   = "Sofiia Cherednychnko"
    Project = "Terraform Lessons"
  }
}
