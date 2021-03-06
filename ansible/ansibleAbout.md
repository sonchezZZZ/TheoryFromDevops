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
3. from playbook move to dir roles/deploy_apache_web, where tasks,vars,files,default exist
4. in playbook add 
            
            roles:
               - deploy_apache_web
            
  or
     
            roles:
               -  {role: deploy_apache_web, when: ansible_system == 'Linux'}
            

## Extra vars

- заменяют все переменные, которые были указаны

1. in playbook:
            
            hosts: {{ MYHOST }}
            
2. in CLI 

            ansible-playbook playbook6.yml --extra-var "MYHOST=STAGING  SECVAR=SOFIIA"   
            
            
## INCLUDE

1. Get tasts
2. Create file create_folder
3. in this file write:

            ---
            - name: Create folder 1
              file:
                 path: /home/secret/folder1
                 state: directory
                 mode: 0755
               
            - name: Create folder 1
              file:
                 path: /home/secret/folder1
                 state: directory
                 mode: 0755               
                 
4. In playbook use:
            
            tasks: 
            - name: Create folders
              include: create_folders.yml    # вставляет по факту
or

            tasks: 
            - name: Create folders
              import: create_folders.yml    # имплементирует с самого начала и добавляет        перменные из vars 
              
or 

            vars: 
             mytext: "Hello"
             
            tasks: 
            - name: Create folders
              include: create_folders.yml   mytext="Hello from Vancouver"   # вставляет по факту
                                                # меняет содежржимое переменной из плейбука для этого файла
              


## Delegating

- Перенаправление задач на определенные сервера

1. In playbook write:

            tasks:
            
            - name: Create file
              copy: 
                dest: /home/file1.txt
                content: |
                    this is FIle1
                    On Rushion {{ mytext }}
              delegate_to: linux3           # do this command only on linux3


## Unregister services 
- runs shell on all servers
- echoes to file in localhost


            tasks:
            - name: Unregister WServer from Load Balancer
              shell: echo this server {{ inventory_hostname }} was deregistered from our Load Balancer >> /home/...
              delegate_to: 127.0.0.1   
              


## WAIT 

            tasks:
            - name: Wait till my server will come up online
              wait_for:
                  host: "{{ inventory_hostname }}"      # wait host
                  state: started                        # wait for state is started
                  delay: 5                              # start waiting after 5 s 
                  timeout: 40                           # wait 40 s
               delegate_to: 127.0.0.1                   # locaalhost(master) will wait
               


## Error Handling

- if not handler, then after failed task all other will not be started

1. Create playbook_errorhandling.yml
2. In this write:

            ---
            - name: Ansible Lesson 19
              hosts: all
              become: yes         # from root
              
              
              tasks:
              - name: Task 1
                yum: name=treeee state:latest
                
              - name: Task 2
                shell: echo Hello 2
                
              - name: Task 3 
                shell: echo Hello 3
 
 Task 1 failed, and so task2 and task3 did not started
 
 #### Add Ignore errors

            ---
            - name: Ansible Lesson 19
              hosts: all
              become: yes         # from root
              
              
              tasks:
              - name: Task 1
                yum: name=treeee state:latest
                ignore_errors: yes              ## if failed, continue other tasks
                
              - name: Task 2
                shell: echo Hello 2
                register: results
                
              - name: Task 3 
                shell: echo Hello 3


#### Add condition when result is failed

            
            ---
            - name: Ansible Lesson 19
              hosts: all
              become: yes         # from root
              
              
              tasks:
              - name: Task 1
                yum: name=treeee state:latest
                ignore_errors: yes              ## if failed, continue other tasks
                
              - name: Task 2
                shell: echo Hello 2
                register: results
                Failed_when: "'World' in results.stdout"   # fail if condition
                
              - name: Task 3 
                shell: echo Hello 3
                
  or 
  
               - name: Task 2
                shell: echo Hello 2
                register: results
                Failed_when: results.rc == 0  # fail if result code = 0

#### Create fatal  errors

- if some task failed, run fatal and stop all tasks for all servers 

            ---
            - name: Ansible Lesson 19
              hosts: all
              any_errors_fatal: true
              become: yes         # from root


## Secret files

- ``ansible-vault create mysecret.txt`` - create file with password 
- ``ansible-vault view mysecret.txt  ``   -  view file with password
- ``ansible-vault edit mysecret.txt  ``   - edit file with password
- ``ansible-vauly rekey file.txt     ``      - change password in secret file

#### SECRET PLAYBOOKS

- ``ansible-vault encrypt playbook_vault.yml`` - зашифровать плейбук
- ``ansible-vault decrypt playbook_vault.yml`` - расшифровать плейбук


1. ``playbook playbook_vault.yml --ask-vault-pass`` - запускать зашифрованые плейбуки

or 

1. create file encrypter.txt 
2. ``ansible-playbook playbook.yml --vault-password-file mypass.txt`` - get password from file 


#### Encrypt Variables

1. ``ansible-vault encrypt_string``
2. print text 
3. copy encrypted password from text ``!vault....``
4. in playbook add to variable encrypted text
5. ``ansible-playbook playbook.yml --ask-vault-pass`` - run playbook with encrypted variables

or

1. echo -n "$%^SECRETPASSWORD&&^%" | ansible-vault encrypt_string
2. add text to playbook
3. run playbook with argument ``--ask-vault-pass`` 
4. and in cofigs will be text in password = SECRETPASSWORD


## Dynamic inventory files AWS ETC2

1. wget http... (find in ansible aws etc2)


In Amazon:
 1. Create user
 2. add permissions  AmazonEC2ReadOnlyAccess, AmazonElasticCacheReadOnlyAccess, AmazonRDSReadOnlyAccess
 3. generate access keys
 
 
 IN MASTER CLI:
 
 1. export AWS_ACCESS_KEY=...
 2. export AWS_SECRET_ACCESS_KEY=...
 3. sudo chmod +x ec2.py
 4. ``./ec2.py --list``  - get servers from aws


## Create resources in Amazon

            tasks:
            - name: Create new AWS EC2 Server
              ec2:
                key_name: "{{ keypair }}"
                instance_type: "{{ inctance_type }}"
                image: "{{ image }}"
                ....
             register: ec2           # Start ec2  
