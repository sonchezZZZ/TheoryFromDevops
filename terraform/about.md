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


### Create terraform folder with plugins

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
   3. ``terraform apply``

- from file 

      provider "aws" {
        access_key = "AKIAW7Z7HKCF6LRNM6GS"                     // from IAM user
        secret_key = "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" // from IAM user
        region     = "us-east-1"                                // regin where to create instances
      }
