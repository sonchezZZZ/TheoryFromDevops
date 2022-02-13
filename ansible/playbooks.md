
##  Check if OS Linux

1. create yml file
2. Wtite for one os
4. check ansible_os_family
5. Add condition on function ``when: ansible_os_family == "RedHat"``

#### Example

        - name: Install for RedHat
          yum:  name=httpd state:latest
          when: ansible_os_family == "RedHat"
          
        - name: Install for Debian
          apt: name=apache2 state=latest
          when: ansible_os_family == "Debian"
          
          
or

#### Example
      
      tasks:
      - name:  Check and Print Linux
      
      - block:    # ===Block FOr RedHat ==== 
      
          - name: Install for RedHat
            yum:  name=httpd state:latest
          
          - name: Copy HomePage file
            copy:  src={{ source_file }} dest= {{ destination_file }} mode=0555
         
        when: ansible_os_family == "RedHat"   # под буквой b
          
          
          


## LOOPS

