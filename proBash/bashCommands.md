# Commands

- **pwd**: Prints the name of the current working directory
- **cd**: Changes the shell’s working directory
- **echo**: Prints its arguments separated by a space and terminated by a newline
- **type**: Displays information about a command
- **mkdir**: Creates a new directory
- **chmod**: Modifies the permissions of a file
- **source**: a.k.a. . (dot): executes a script in the current shell Environment
- **printf**: Prints the arguments as specified by a format string

- **cat**: Prints the contents of one or more files to the standard output
- **tee**: Copies the standard input to the standard output and to one or more files
- **read**: A builtin shell command that reads a line from the standard input
- **date**: Prints the current date and time

# Concepts
- **Script**: This is a file containing commands to be executed by the shell.
- **Word**: A word is a sequence of characters considered to be a single unit by the shell.
- **Output redirection**: You can send the output of a command to a file rather than the terminal using > FILENAME.
- **Variables**: These are names that store value
- **Pipelines**: A pipeline is a sequence of one or more commands separated by |; the standard output of the command preceding the pipe symbol is fed to the standard input of the command following it.

# Examples of commands 

- **cp** : copy file or directory

      touch test
      cp apple another_apple
      
      mkdir fruits
      cp -r fruits cars

- **guzip** : removes .gz and putting in the ```filename``` file.

      gunzip filename.gz

You can extract to a different filename using output redirection using the -c option

      gunzip -c filename.gz > anotherfilename

- **ps** : search processes

      ps 
      ps axww | grep "docker"   - **find processes with such name**
      
- ps ax 

      The **a** option is used to also list other users' processes, not just your own. 
      
      **x** shows processes not linked to any terminal (not initiated by users through a terminal).
### JOBS command

- **&** ```top &```
- **fg** :   We can get back to that program using the fg command. 
- **fg number**   ```fg 3```
- jobs   : To get the job number, we use the jobs command.

![image](https://user-images.githubusercontent.com/79608549/151985610-5efffa33-ee3f-4f4c-bfaf-8a9180f90a8f.png)

### Searching

#### Search in files 

- **grep**   | You can use grep to search in files, or combine it with pipes to filter the output of another command.
- ```-n``` : for displaying number of line 

            grep -n document.getElementById index.md

- ```-C``` :  accepts a number of lines 
- ```number``` :  One very useful thing is to tell grep to print 2 lines before and 2 lines after the matched line to give you more context.

      grep -nC 2 document.getElementById index.md
      
- Search is case sensitive by default. Use the ```-i``` flag to make it insensitive.

### search files and packages 

- **find .**   : key word
- ```'*.js'``` : searching phrase
 
      find . -name '*.js'
      
- ```-type d``` : find directories
- ```-type f``` : find file
- ```-type l``` : find symbolic links

      find . -type d -name src

- ```find``` foldername1, foldername2 : search in multiple root trees

      find folder1 folder2 -name filename.txt

## BASH SCRIPTS

### Conditions 

       #!/bin/bash
       echo "Введите ваш возраст"
       read age
       if [[ $age -ge 0 ]] && [[ $age -lt 12 ]]; then
                  echo "Вы еще ребенок"
            elif [[ $age -ge 12 ]] && [[ $age -lt 18 ]]; then
                  echo "Вы подросток"
            elif [[ $age -ge 18 ]] && [[ $age -lt 60 ]]; then
                  echo "Вы уже взрослый"
            else
                  echo "Вы старичок"
       fi
       
### SWITCH CASE

      #!/bin/bash
      echo "Введите марку телефона"
      read brand
      case $brand in
            samsung)
                  echo "Скидка на телефоны $brand - 30%";;
            nokia)
                  echo "Скидка на телефоны $brand - 10%";;
            huawei)
                  echo "Скидка на телефоны $brand - 20%";;
            *)
                  echo "На этот вид товара скидок нет"
      esac
      
### INSERTING CONDITIONS

            #!/bin/bash
            echo "Введите марку телефона"
            read brand
            if [[ $brand == "samsung" ]] || [[ $brand == "nokia" ]] || [[ $brand == "huawei" ]] || [[ $brand == "iphone" ]]; then
                  case $brand in
                      samsung)
                            echo "Скидка на телефоны $brand - 30%";;
                      nokia)
                            echo "Скидка на телефоны $brand - 10%";;
                      huawei)
                            echo "Скидка на телефоны $brand - 20%";;
                      *)
                            echo "На этот вид товара скидок нет"
                esac
            fi
            
  #Решение при помощи вложенного if
  
            echo "Введите марку телефона"
            read brand
            if [[ $brand == "samsung" ]] || [[ $brand == "nokia" ]] || [[ $brand == "huawei" ]] || [[ $brand == "iphone" ]]; then
                  if [[ $brand == "samsung" ]]; then
                        echo "Скидка на $brand - 30%"
                  elif [[ $brand == "nokia" ]]; then
                        echo "Скидка на $brand - 10%"
                  elif [[ $brand == "huawei" ]]; then
                        echo "Скидка на $brand - 20%"
                  else
                        echo "На данный вид товара скидок нет"
                  fi
             else echo "$brand - не марка телефона."
            fi
### ARRAYS

- ```Array=(1 6 3 8 15)```
-  ```Array2=(1 2 3 4 «five»)```
-  ```echo ${Array[@]}```       : output all elements of array
- ```«${Array[@]}»```           : output if value of elements exist whitespaces
- ```echo ${!Array[@]}```       : ouput indexes of elements
- ```echo ${Array[2]}```        : output 2 element of array
- ```${#Array[@]}```            : count of array indexes 
- ```echo ${#Array[индекс]}```  : lenght of element by index
- ```Array[2]=32```             : set value to 2 element of array

- foreach for elements in array

      for i in ${Array[@]}; do
            echo «${Array[$i]}»
      done

- foreach for indexes in array

      for i in ${!Array[@]}; do
            echo «${Array[$i]}»
      done

### LOOPS

- example

      for i in list;
          do
            commands;
      done  

- FOR I IN RANGE


      #!/bin/bash
      # Цикл for
      for n in 1 2 3;
            do
                  echo "$n"
      done
- FOR I SUCH AS JAVA
      
      # Альтернативный вариант цикла for
      for (( i = 0; i < 10; i++ )); do
            echo "$i"
      done
      
- WHILE LOOP 

     
      # Цикл while
      n=1
      while [ $n -lt 4 ]
            do
                  echo "$n"
                  n=$(( $n+1 ));
      done

### Comparing 

- -eq (equals), 
- -ne (not equals)
- -g (greater then), 
- -lt (less then),
- -ge (greater or equels), and 
- -le (less or equals) operators. 
