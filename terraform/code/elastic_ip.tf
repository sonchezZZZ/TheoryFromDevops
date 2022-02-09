resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server IP" })

  /*
  tags = {
    Name    = "Server IP"
    Owner   = "Denis Astahov"
    Project = "Phoenix"
  }
*/

}
