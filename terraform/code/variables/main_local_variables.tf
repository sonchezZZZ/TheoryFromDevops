provider "aws"{}

resource "aws_instance" "my_Ubuntu" {              // aws instance with name my_Ubuntu                     // count of created servers with such parameters
  ami                    = "ami-0e472ba40eb589f49" // server image  from amazon
  instance_type          = var.instance_type              // instance type from amazon
  monitoring = var.detail_monitoring
}

data "aws_region" "regionAws" {}
data "aws_availability_zones" "availabilities" {}


locals {
  full_project_name = "${var.env}.${var.project_name}"
  region = data.aws_region.regionAws
  az_list = join(",", data.aws_availability_zones.availabilities.names)
}


resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_Ubuntu.id
  tags ={
    Name = "Static IP"
    Owner = local.full_project_name
  }
}
