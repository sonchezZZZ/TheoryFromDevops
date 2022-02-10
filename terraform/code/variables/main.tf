provider "aws"{}

resource "aws_instance" "my_Ubuntu" {              // aws instance with name my_Ubuntu                     
  ami                    = "ami-0e472ba40eb589f49" // server image  from amazon
  instance_type          = var.instance_type              // instance type from amazon
  vpc_security_group_ids = [aws_security_group.my_web_server.id]
  monitoring = var.detail_monitoring
}


resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_Ubuntu.id
  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Server build"})
}

resource "aws_security_group" "my_web_server" { // Creating new security group

  dynamic "ingress" {

    for_each = var.allow_ports
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

    tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Secure group"})   // add list common tags, then create name = environment from var. common tags (map) 
                                                                                               // get environment value and concat text
}
