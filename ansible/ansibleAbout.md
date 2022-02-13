# Ansible 

Ansible - автоматизация настройки конфигураций для серверов

# Commands

- **pull**  - на управляемых серверах установлен агент, который делает pull настроек от Мастер
- **push**  -  на управляемых серверах ничего не установлено, Master делает Push настроек
- **ansible-inventory --list**  - все группы, сервера и переменные 
- **ansible -i hosts.txt all -m ping**   - ping to all servers

# Connecting to servers

1. Create servers(one master and other )
2. Ansible master program download
3. in master aa ssh keys of servers in (cd .ssh)



## WOrk with ansible

1. Create keys ssh 
2. chmod 400 path/to/key
3. Create inventory (hosts.txt)

## Inventory
1. Create file hosts.txt
2. Fill it
3. Create file 

### Example of Inventory

      [prod_web]   //name of server group 
      ubuntu3 ansible_host=54.236.179.159

      [prod_db]
      ubuntu2 ansible_host=54.159.192.83

      [prod_ALL:children]   //main group with children servers
      prod_web
      prod_db

      [prod_ALL:vars]     //variables of all servers that parent is prod_ALL
      ansible_user=ubuntu
      ansible_ssh_private_key_file=/home/ubuntu/.ssh/sonya-key-Virgini.pem












