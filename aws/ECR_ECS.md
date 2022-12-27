# AWS ECR 

Types: 
- private
- public

AWS ECR (Elastic Container Registry) - container registry for storing Docker images. 

How it works: Once a Docker client has been autorisd it can push and pull to and from the ECR registry.

When it usefull: When you don`t want to use dedicated registry 

How to use: 
1. Create docker-registry
    - copy "view push commands"
2. Create instance 
3. create iam role for instance: ```instance  > action > attach_role_for_this_instance```
    - Create role with policy "AmazonElasticContainerRegistryPublicFullAccess"
4. Configure Instance 
    - Create dockerfile
    - docker build dockerfile my-folder
    - install awscli
    - past "view push commannds -> Retrieve access token"
    
5. sudo docker push ecr-url 

# AWS ECS

**AWS ECS (Elastic Container Service)** - orchestration service 

ECS - aws service that allows us to orchestrate our software deployment. It acts like any other orchestration tool like Kubernetes or Docker Swarm. 
It allows us to depoly, update, rollback, scale up our software development

### Deploy website on ECS

1. Create ECS container 
    - copy ecr registry url > past to image part
    - Configure network 
    - go to ec2 -> check instance from ecs
    - go to load balancers -> check load balancer
    
2. Configuration 
   - services - > our service
   - tasks  
   - ecs instances - > our ec2 instances 
3. Elements 
   - task definitions (select launch type compability fargate or ec2)
   
