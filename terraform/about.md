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
    
