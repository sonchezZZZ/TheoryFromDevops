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
- 

