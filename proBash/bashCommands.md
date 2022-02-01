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

            grep -n document.getElementById index.md

- ```-n``` : for displaying number of line 
