# Containers

- **docker continer create --name redis redis** - создать контейнер из образа
- **docker run obj** - запустить контейнер с образом
- **docker run obj5:0** - запустить контейнер с образом определенной версии
- **docker run -it obj** - запустить с консолью в интерактивном режиме
- **docker run obj -p 80:5000** - запустить с пробросом портов на локальную машину   **docker run -p 30123:8080 rotorocloud/simple-webapp-rockets:v2          **
- **docker run -v opt/datadir/mysql:/var/lib/mysql mysql** - запустить контейнер с хранилищем из(докер хост) куда(в контейнере)  
- **docker run obj -d** - запустить в фоновом режиме и не тушить (detach mode)
- **docker run -it obj sh** - запустить и войти в сервис внутри контейнера
- **docker pull obj** - скачать образ с Докер Хаб
- **docker ps** - список работающих контейнеров
- **docker ps -a** - показать все контейнеры
- **docker stop container-name** - прервать работу контейнера 
- **docker rm cont-name** - удалить контейнер
- **docker rm $(docker ps -a -f status=exited -q)** - delete all containers with status exited

## Удалить все запущеные контейнеры: 

- **docker rm -f $(dcoker ps -aq)**
- **docker container rm -f $(docker container ls -aq)**
- **docker container rm -f $(docker container ps -aq)**

# Images 
- **docker images** - list of images 
- **docker rmi image-name** - delete image



**docker inspect object** - инспекция контейнера
**docker logs obj** - логи контейнера
**docker attache obj** - зайти в консоль контейнера 
