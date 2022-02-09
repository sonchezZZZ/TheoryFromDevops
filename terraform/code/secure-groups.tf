provider "aws" {
  access_key = "****"                     // from IAM user
  secret_key = "*****" // from IAM user
  region     = "us-east-1"                                // regin where to create instances
}

resource "aws_instance" "my_Ubuntu" {              // aws instance with name my_Ubuntu
  count                  = 1                       // count of created servers with such parameters
  ami                    = "ami-0e472ba40eb589f49" // server image  from amazon
  instance_type          = "t2.micro"              // instance type from amazon
  vpc_security_group_ids = [aws_security_group.my_web_server.id]
}

resource "aws_security_group" "my_web_server" { // Creating new security group

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group"
  }
}


// --------------------------------   or if several ports -----------------------
  
resource "aws_security_group" "my_web_server" { // Creating new security group

  dynamic "ingress" {

    for_each = ["80","443"]
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      }
    }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group"
  }
}
