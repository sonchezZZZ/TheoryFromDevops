provider "aws"{}

resource "random_string" "aws_password" {
  length = 12
  special = true
  override_special = "!&#"    //what special will be used
}

resource "aws_ssm_parameter" "aws_password"{
  name = "/prod/mysql"
  description = "Cluster password for RDS MySql"
  type = "SecureString"
  value = random_string.aws_password.result
 }


data "aws_ssm_parameter" "my_aws_password" {
  name = "/prod/mysql"
  depends_on = [aws_ssm_parameter.aws_password]
}

output "aws_pass" {
  value = data.aws_ssm_parameter.my_aws_password.value
  sensitive = true
}
