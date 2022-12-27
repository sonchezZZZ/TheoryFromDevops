# What is orchestration

# Docker Swarm

## Configure Docker swarm on instances 

On Master node: 
```sudo docker swarm init --advertise-addr master-ip```

On worker node 
``` sudo docker swarm join --token TOKEN ip:port```

## Commands 

- **docker node ls** - node list
- **docker node rm node-id** - delete node 
- **docker info** - swarm info
- **docker swarm leave** - unset worker node
- **docker swarm join-token worker** - get joining command for worker node
- **docker swarm join-token manager** - get joining command for master node
- **docker service create --name fun -replicas 3 -p 80:80 httpd**
- **docker service ls**
- **docker service ps service-name**
- **docker stack deploy -c docker-compose.yaml fun** - create deployment
- **docker service scale svc-name=3**
- **docker service update --image image-name/version service-id**

