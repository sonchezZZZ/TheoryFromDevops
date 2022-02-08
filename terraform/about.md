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
      
      
## Add Security Group

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
