# Terraform

- **Синтаксис**  HCL
- **File format** .tf
- не требует компиляции
- Работает на всех оперц. системах
- любой текстовый редактор

### Альтернативы 

- AWS CloudFormation
- Ansible
- Puppet
- Chef

``` terraform show ```   - show resources from file tf

## Look instances from EC2

``aws wc2 describe-instances``

### Create instance

1. create folder
2. create new .tf file 
3. go to this folder from the terminal 
4. write ```terraform init```
5. press `Enter`

- ```terraform plan``` - plan to terraform will make
- ```terraform apply``` - create instance in amazon

### Change instance 

1. change .tf file
2. Enter ```terraform plan```
3. Enter ```terraform apply``` 


## View How to do 

1. open terraform url
2. view examples


## Delete instances 

- **if from count 3 to count 2**, 
  1. ``change in file`` 
  2. ``terraform apply``
  
- **if delete whole resource**
  1. ``delete resource in file``
  2. ``terraform apply``
  
- **delete all resources in file**
  1. ```terraform destroy```



##  Ways to set access keys 

- from command line
   1. ``export AWS_ACCES_KEY_ID=accesKey``
   2. ``export AWS_SECRET_ACCES_KEY=accessSecretKey``
   3. ``in file write region`` or ``export AWS_DEFAULT_REGION=eu-central-1`` 
   4. ``terraform apply``

- from file 

      provider "aws" {
        access_key = ""                     // from IAM user
        secret_key = "" // from IAM user
        region     = "us-east-1"                                // regin where to create instances
      }


## Add scripts for server 

1. From resource 


        resource "aws-instance" "ubuntu"{
        ...
            user_data    = <<EOF
            #/bin/bash
            yum -y
            yum -y install httpd
            myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
            echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
            sudo service httpd start
            chkconfig httpd on
            EOF
        }

2. From external files 

        resource "aws_instance" "my_Ubuntu" {              // aws instance with name my_Ubuntu
          ...
          user_data              = file("script.sh")

        }
 
 3. From dynamic files
        
        resource "aws_instance" "my_webserver" {
              ...
              user_data = templatefile("user_data.sh.tpl", {
                f_name = "Denis",
                l_name = "Astahov",
                names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha"]
              })
         }     


      
      
## CHECK SCRIPT CODE FROM CLI      

        1. terraform console
        2. file("script.sh.tpl")
        3. templatefile("user_data.sh.tpl", {
                f_name = "Denis",
                l_name = "Astahov",
                names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha"]
              })


## DYNAMIC BLOCKS

      resource "aws_security_group" "my_webserver" {
        ...
        dynamic "ingress" {
          for_each = ["80", "443", "8080", "1541", "9092", "9093"]
          content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
          }
        }
        
        ingress {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.10.0.0/16"]
        }
        ...
      }
      
      
# Add Security Group

1.

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

2. in instances:

        vpc_security_group_ids = [aws_security_group.my_webserver.id]
    


## Configure  Lifecycle

-   if something changing from tf file will destroy instance, it will throw error

         lifecycle {
            prevent_destroy = true 
         }
Это можно использовать в качестве меры защиты от случайной замены объектов, воспроизведение которых может быть дорогостоящим, например, экземпляров базы данных. Однако это сделает невозможным применение определенных изменений конфигурации и предотвратит использование terraform destroy команды 

обратите внимание, что этот параметр не предотвращает уничтожение удаленного объекта, если resource блок был полностью удален из конфигурации: в этом случае prevent_destroy параметр удаляется вместе с ним, и, таким образом, Terraform позволит успешно выполнить операцию по уничтожению. 

-   ignore changes in such fields and not apply in this resource


         lifecycle {
                 ignore_changes = ["ami","user_data"] 
         } 

- create new instance before deleted last 

        resource "azurerm_resource_group" "example" {
          # ...

          lifecycle {
            create_before_destroy = true
          }
        }
        
        
## Set elastic ip adress for instance

    resource "aws_eip" "my_static_ip" {
      instance = aws_instance.my_webserver.id
      tags = {
        Name  = "Web Server IP"
        Owner = "Denis Astahov"
      }
    }

## OUTPUT from terraform commands

``` terraform show ```   - show resources from file tf

- new file output.tf

in this file:
- id of instace

      output "webserver_instance_id"{
        value = aws_instance.instance_name.id     //value that will be print in console
        description = "some description"          // description that will be show only in file
      }

- elastic ip 

       output "webserver_public_ip_adress"{
        value = aws_eip.eip_name.public_ip
      }


## Priority for creating instances

1. create main.tf
2. in resource that will created latest other,  write

        depends_on = [aws_instance.instance-name-that-need-create-before-this]
- if need several before that instance

        depends_on = [aws_instance.instance-name-that-need-create-before-this,aws_instance.instance-  name-that-need-create-before-this]


## DataSource from aws 

1. Get aws data 

        data "aws_region" "region" {}
        
2. Output aws data
       
        output "data_region_name" {
          value = data.aws_region.region.name
        }
       

## AMI id from datasource 

### PLUS = works for all regions 

1. In AWS Launch instances -> copy id 
2. in AWS Images-AMIs -> paste for source 
3. copy nam eand owner 
4. in tf file create **data**

          data "aws_ami" "latest_ubuntu" {
            owners      = ["099720109477"]   // from aws
            most_recent = true
            filter {
              name   = "name"
              values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]    // from aws
            }
          }
5. For ,for example, output, use:

            output "latest_ubuntu_ami_id" {
              value = data.aws_ami.latest_ubuntu.id
            }

            output "latest_ubuntu_ami_name" {
              value = data.aws_ami.latest_ubuntu.name
            }

## Variables 

[link (variables.md)] 


# Storage for password
1. create password 


        resource "random_string" "aws_password" {
          length = 12
          special = true
          override_special = "!&#"    //what special will be used
        }

2. save in Amazon aws parameter store


        resource "aws_ssm_parameter" "aws_password"{
          name = "/prod/mysql"
          description = "Cluster password for RDS MySql"
          type = "SecureString"
          value = random_string.aws_password.result
         }

3. Get from Amazon

          data "aws_ssm_parameter" "my_aws_password" {
            name = "prod/mysql"
            depends_on = [aws_ssm_parameter.aws_password]
          }


## Поднимать instances на разных регионах 

1. Создать Провацдеров с разными регионами

        provider "aws" {
          region = "ca-central-1"
        }

        provider "aws" {
          region = "us-east-1"
          alias  = "USA"
        }

        provider "aws" {
          region = "eu-central-1"
          alias  = "GER"
        }
        
2. Создать images для instances

          data "aws_ami" "defaut_latest_ubuntu" {
            owners      = ["099720109477"]
            most_recent = true
            filter {
              name   = "name"
              values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
            }
          }

          data "aws_ami" "usa_latest_ubuntu" {
            provider    = aws.USA
            owners      = ["099720109477"]
            most_recent = true
            filter {
              name   = "name"
              values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
            }
          }

        
4. Добавить этих провайдеров  в instances


          resource "aws_instance" "my_default_server" {
            instance_type = "t3.micro"
            ami           = data.aws_ami.defaut_latest_ubuntu.id
            tags = {
              Name = "Default Server"
            }
          }

          resource "aws_instance" "my_usa_server" {
            provider      = aws.USA
            instance_type = "t3.micro"
            ami           = data.aws_ami.usa_latest_ubuntu.id
            tags = {
              Name = "USA Server"
            }
          }
       


## Безболезненное удаление instance 

- если версия 15.1
- пометить на пересоздание после apply   ``` terraform taint aws_instance.node2```
- еще раз сделать terraform apply 
 
 #### or
 
-  если версия 15.2+  ``` terraform apply -replace aws_instance.node2``` 
