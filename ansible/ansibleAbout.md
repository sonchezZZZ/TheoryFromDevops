# Ansible 

Ansible - автоматизация настройки конфигураций для серверов

# Commands

- ``pull``  - на управляемых серверах установлен агент, который делает pull настроек от Мастер
- ``push``  -  на управляемых серверах ничего не установлено, Master делает Push настроек
- ``ansible-inventory --list``  - все группы, сервера и переменные 
- ``ansible-inventory --graph``  - все группы серверов в виде графа
- ``ansible -i hosts.txt all -m ping``   - ping to all servers

## AD HOC COmmand of ansible

- ``ansible all -m setup``   -  properties of the servers
- ``ansible all -m shell -a "uptime"``  - run commands in servers, where ``-a`` - bash command
- ``ansible all -m command -a "pwd"`` - run commands in servers, BUT not using arguments
- ``ansible all -m copy -a "src=path/to/source dest=/path/to/servers/directories" -b ``- copies file from master to servers, where ``-b`` - allows write as root user
- `` ansible all -m file -a "path=/home/path/to/file state=absent -b" `` - deletes file from servers
- `` ansible all -m get_url -a "url=https://pathtofile" -b `` - download file in all servers
- `` ansible all -m yum -a "name=stress state=installed -b" `` - install program stress in all servers
- `` ansible all -m  yum -a "name=stress state=removed -b"`` - uninstall programm from all servers
- `` ansible all -m uri -a "url=http://www.adv-it" `` - get content from url (curl)
- `` ansible all -m uri -a "url=http://www.adv-it return_content=yes" `` -  get content(curl) and return this
- `` ansible all -m service -a "name=https state=started enabled=yes" -b `` - start http page in servers
- `` ansible all -m ... ... -v `` - run with dubugs or ``-vv``, ``-vvv``, ``-vvvv``
- `` ansible-doc -l`` - commands from ansible     



# Connecting to servers

1. Create servers(one master and other )
2. Ansible master program download
3. in master aa ssh keys of servers in (cd .ssh)



## WOrk with ansible

1. Create keys ssh 
2. chmod 400 path/to/key
3. Create inventory (hosts.txt)
4. Create ansible.cfg
5. fill ansible.cfg


            [defaults]
            host_key_cheking = false
            inventory        = ./hosts.txt

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


## Variables from hosts.txt

1. Create hear hosts directory `group_vars` 
2. Create in this dir file  (for example, if in hosts was [prod_ALL:vars] name of file = **prod_ALL**)
3. File:

            ---
            ansible_user : ubuntu
            ansible_ssh_private_key_file : /home/ubuntu/.ssh/sonya-key-Virgini.pem

## Playbook

- Playbook - it is yml file
1. Create file playbook1.yml 
2. ``Ansible-playbook playbook1.yml`` - connect with playbooks
3. Example of file

 
            ---
            - name: Test Connections
              hosts: all
              become: yes

              tasks:

              - name: Ping my servers
                ping:

## Template

- file from html , where we can write global variables in html 

1. Create file from index.html to index.j2
2. in this file we can write

               <font colot="gold"> Owner of this Server is: {{ owner }} </br>
               
               
               <h1>Server OS family is: {{ansible_os_family }} </h1>
               
3. in playbook 

            
            - name: Generate INDEX_HTML file
              template: src={{ source_folder }}/index.j2   dest={{ destin_folder }} mode=0555
              notify: 
                        ....


## Roles

1. mkdir roles
2. ``ansible -galaxy init deploy_apache_web`` in dir roles
3. 
