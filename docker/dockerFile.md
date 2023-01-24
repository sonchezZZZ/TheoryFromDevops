**Docker** builds images automatically by reading the instructions from a Dockerfile -- a text file that contains all commands, in order, needed to build a given image. A Dockerfile adheres to a specific format and set of instructions which you can find at Dockerfile reference.

# Structure 

```
FROM dockerfile/ubuntu

# Install MongoDB.
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get install -y mongodb-org && \
  rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/data/db"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mongod"]

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017
```

## Commands 

- CMD = команда, которая будет запускать после запуска программы
- ENTRYPOINT = такая же команда, как CMD, но CMD заменяет параметры, а EntryPoint позволяет добавлять параметры

```
CMD sleep 5
```

```
ENTRYPOINT ["sleep"]
# AND 
# Docker run without parameter will be error
docker run ubuntu-sleeper 10
```
</br>

Чтобы использовать Ентрипоинт без параметра,, нужно использовать два поля CMD и ENTRYPOINT, например 
```
ENTRYPOINT ["sleep"]
CMD sleep 5

# мы используем CMD для предоставления аргумента по умолчанию для инструкции ENTRYPOINT

# AND 
docker run ubuntu-sleeper
```

Если нужно переиспользовать Ентрипоинт в этом случае, нужно:
```
docker run --entrypoint super-sleep 10 ubuntu-sleeper 10 
```


## What are the contents of a Dockerfile?

The Dockerfile example that’s used in the demonstration uses the following instructions. These instructions were used as a good starting point for learning. For more information about Dockerfile instructions, see Dockerfile reference.

```bash
FROM: Defines the base image. All the instructions that follow are run in a container launched from the base image.
WORKDIR: Sets the working directory for the subsequence instructions.
ENV: Sets environment variables.
COPY: Copies files and directories into the container image.
RUN: Runs commands in the new container. This instruction commits a new layer on top of the present layer.
CMD: Sets the default command to run when the container is launched.
EXPOSE: Is used to document the containers that the port exposes.
```

## Docker commands

For more information, see the full reference for the docker base command.

- docker build: Builds an image from a Dockerfile. In the demonstration, we pass -t to tag the image that’s created.
- docker run: Creates and starts a container. In the demonstration, we use -p to expose ports, -e to set environment variables, and -v to bind mount volumes.
- docker exec: Runs a command in a running container.
- docker stop: Stops a container.
- docker rm: Removes a container. Use -f to force the remove.
