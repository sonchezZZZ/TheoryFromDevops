# Docker storages 

## What Is Docker Storage? ^
![image](https://user-images.githubusercontent.com/79608549/209439502-cc1dbf21-8e9a-46c3-8b8d-1e4cff2901b4.png)

- Контейнеры не записывают данные постоянно в какое-либо место хранения. 
- Хранилище Docker должно быть настроено, если вы хотите, чтобы ваш контейнер постоянно хранил данные. 
- Данные не превалируют при удалении контейнера (командой remove); это происходит потому, что когда контейнер удаляется, слой, доступный для записи, также удаляется.
- Если данные хранятся вне контейнера, вы можете использовать их, даже если контейнер больше не существует.

## Manage Data In Docker ^
По умолчанию все файлы, созданные внутри контейнера, хранятся на доступном для записи уровне контейнера. 
Это говорит о том, что:
- Данные не сохраняются, когда этот контейнер больше не существует, и часто бывает трудно извлечь данные из контейнера, если они нужны другому процессу.
- Доступный для записи уровень контейнера тесно связан с хост-компьютером, на котором работает контейнер. Вы не можете легко переместить данные в другое место.
- Для записи в доступный для записи уровень контейнера требуется драйвер хранилища для управления файловой системой.

## Docker Storage Types ^
![image](https://user-images.githubusercontent.com/79608549/209439479-60f51d95-0d67-4241-9b9d-c07e6f844935.png)

Типы хранилищ DockerХранилище Docker различает три типа хранилищ. Два типа являются постоянными: **тома Docker и привязки Mounts**, а третий способ записи данных — **tmpfs**. С точки зрения контейнера, он не знает, какое хранилище используется.

Разница между ними в том, что **volumes** имеют выделенную файловую систему на хосте (/var/lib/docker/volumes) и напрямую управляются через интерфейс командной строки Docker. С другой стороны, при **mount** привязки используется любая доступная файловая система хоста. В то время как **tmfs** использует память хоста.

## Docker Volume Use Case ^
**Docker Volumes** — наиболее часто используемая технология для постоянного хранения данных контейнера. Docker Volumes управляется самим Docker и имеет выделенную файловую систему на хосте, не зависит от структуры файловой системы на хосте. Docker Volumes явно управляются через командную строку Docker и могут создаваться отдельно или во время инициализации контейнера. 
Используемая команда — ```docker volume create```

When stopping or deleting a container, Docker volume remains permanently stored. The volumes are often manually deleted with the docker volume prune command. Multiple containers can be connected to the same Docker volume.

## Docker Bind Mount ^
Docker bind mount — это второй вариант постоянного хранилища, но с более ограниченными возможностями, чем Docker Volumes. Им нельзя управлять через интерфейс командной строки Docker, и он полностью зависит от доступности файловой системы хоста. Файловая система хоста может быть создана при запуске контейнера. Связные монтирования — это своего рода надмножество томов (именованных или безымянных).

Commands:
```bind mount: note that the host path should start with ‘/’. Use $(pwd) for convenience.```

```docker container run -v /host-path:/container-path image-name```
unnamed volume: creates a folder in the host with an arbitrary name

```docker container run -v /container-path image-name  ```
named volume: should not start with ‘/’ as this is reserved for bind mount. ‘volume-name’ is not a full path here. the command will cause a folder to be created with path “/var/lib/docker/volume-name” in the host.

```docker container run -v volume-name/container-path image-name```


## tmpfs Mounts ^

tmpfs — это третий вариант хранилища, который не является постоянным, как Docker volume or bind mount. Данные записываются непосредственно в память хоста и удаляются при остановке контейнера. 
> Очень полезно, когда речь идет о конфиденциальных данных, которые вы просто не хотите хранить постоянно. Действительно существенное отличие заключается в том, что контейнеры не могут совместно использовать пространство tmpfs, если только они не работают в ОС Linux. При создании тома tmpfs используются два флага: tmpfs и mount. Флаг монтирования новее и поддерживает несколько параметров во время запуска контейнера. Временные файловые системы записываются в ОЗУ (или в файл подкачки, если ОЗУ заполняется), а не на хост или собственный слой файловой системы контейнера на Docker.com: Docker tmpfs.

**Commands**:
```
docker run -d --name tmptest --mount type=tmpfs,destination=/app nginx:latest
docker run -d --name tmptest --tmpfs /app nginx:latest
```

## Network File System (NFS) ^
![image](https://user-images.githubusercontent.com/79608549/209439465-980f3f7d-331b-4ccb-afd3-7a5e21881823.png)

**NFS in Docker**

When you create a container, you are going to be fairly limited to the amount of space in that container. This is exacerbated when you run multiple containers on the same host. So, to get around that, you could mount an NFS share at the start of the container. With NFS, my storage limits are only what my storage provider dictates. Access to a unified set of data across all containers. One thing you’ll notice while learning Docker is that the container OS is nothing like a virtual machine. These containers are essentially thin clients and are missing some functionality by design.

Creating The NFS Docker Volume :
Here is the command to create an NFS type Docker volume in reading / write access from an existing NFS export :

# docker volume create --driver local --opt type=nfs --opt o=addr=<adresse ip serveur nfs>,rw --opt device=:<chemin export nfs> <nom du volume NFS Docker>

## Docker Storage Driver ^
  ![image](https://user-images.githubusercontent.com/79608549/209439462-0b844296-d96b-4978-89db-72043ba4183e.png)

Docker Storage DriverDocker storage driver is liable for creating a container write layer to log all the changes during container runtime. When a container is started with an image, all layers that are part of the image are locked and read-only. Changes are written to the recording layer and deleted when the container is stopped. The driver creates a Union filesystem that allows filesystems to be shared from all layers. This is the default way to store data in a container unless the storage technologies described above are used. It’s important to notice that an additional driver layer brings additional performance overhead. It’s not recommended to use the default storage option for write-intensive containers like database systems.  
