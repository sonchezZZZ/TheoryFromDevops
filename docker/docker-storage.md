# Docker storages 

## What Is Docker Storage? ^
![image](https://user-images.githubusercontent.com/79608549/209439502-cc1dbf21-8e9a-46c3-8b8d-1e4cff2901b4.png)

Containers don’t write data permanently to any storage location. Docker storage must be configured if you would like your container to store data permanently. The data doesn’t prevail when the container is deleted (using the remove command); this happens because when the container is deleted, the writable layer is also deleted. If the data is stored outside the container you can use it even if the container no longer exists.

## Manage Data In Docker ^
By default, all files created inside a container are stored on a writable container layer. This suggests that:
- The data doesn’t persist when that container no longer exists, and are often difficult to urge the data out of the container if another process needs it.
- A container’s writable layer is tightly coupled to the host machine where the container is running. You can’t easily move the data somewhere else.
- Writing into a container’s writable layer requires a storage driver to manage the filesystem.

## Docker Storage Types ^
![image](https://user-images.githubusercontent.com/79608549/209439479-60f51d95-0d67-4241-9b9d-c07e6f844935.png)

Docker storage typesDocker storage distinguishes three storage types. Two types are permanent: Docker volumes and bind Mounts and the third way of writing data is tmpfs. From the container perspective, it doesn’t know what sort of storage is in use.

The difference between these is, volumes have a dedicated filesystem on the host (/var/lib/ docker/volumes) and are directly controlled through the Docker CLI. On the other hand, bind mounts use any available host filesystem. Whereas tmfs, uses the host memory.

## Docker Volume Use Case ^
Docker volume is the most commonly used technology for the permanent storage of container data. Docker volume is managed by Docker itself and has a dedicated filesystem on the host, doesn’t depend upon the filesystem structure on the host. Docker volumes are explicitly managed via the Docker command line and can be created alone or during container initialization. The command used is docker volume create.

When stopping or deleting a container, Docker volume remains permanently stored. The volumes are often manually deleted with the docker volume prune command. Multiple containers can be connected to the same Docker volume.

## Docker Bind Mount ^
Docker bind mount is the second permanent storage option but with more limited options than Docker volume. It can’t be managed via Docker CLI and is totally dependent on the availability of the filesystem of the host. A host filesystem can be created when running a container. Bind mounts are a sort of superset of Volumes (named or unnamed).

Commands:
```bind mount: note that the host path should start with ‘/’. Use $(pwd) for convenience.```

```docker container run -v /host-path:/container-path image-name```
unnamed volume: creates a folder in the host with an arbitrary name

```docker container run -v /container-path image-name  ```
named volume: should not start with ‘/’ as this is reserved for bind mount. ‘volume-name’ is not a full path here. the command will cause a folder to be created with path “/var/lib/docker/volume-name” in the host.

```docker container run -v volume-name/container-path image-name```


## tmpfs Mounts ^
tmpfs is a third storage option that is not permanent like Docker volume or bind mount. The data is written directly on to the host’s memory and deleted when the container is stopped. Very useful when it involves sensitive data that you simply don’t want to be permanent. A really significant difference is that containers can’t share tmpfs space unless they’re running on Linux OS. Two flags are used when creating tmpfs volume: tmpfs and mount. Mount flag is newer and supports multiple options during container startup.  Temporary filesystems are written to RAM (or to your swap file if RAM is filling up) and not to the host or the container’s own filesystem layer at Docker.com: Docker tmpfs.

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
