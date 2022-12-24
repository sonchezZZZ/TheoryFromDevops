# Docker storages 

## Manage Data In Docker ^
By default, all files created inside a container are stored on a writable container layer. This suggests that:
- The data doesn’t persist when that container no longer exists, and are often difficult to urge the data out of the container if another process needs it.
- A container’s writable layer is tightly coupled to the host machine where the container is running. You can’t easily move the data somewhere else.
- Writing into a container’s writable layer requires a storage driver to manage the filesystem.

## Docker Storage Types ^
Docker storage typesDocker storage distinguishes three storage types. Two types are permanent: Docker volumes and bind Mounts and the third way of writing data is tmpfs. From the container perspective, it doesn’t know what sort of storage is in use.
