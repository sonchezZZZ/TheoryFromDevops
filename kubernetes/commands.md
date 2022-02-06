# Main commands 

- ```kubectl apply -f podname.yaml ``` - create pod from yaml file
- ```kubectl delete -f podname.yaml ``` - delete pod with yaml file



Let’s verify that the application we deployed in the previous scenario is running. We’ll use the kubectl get command and look for existing Pods:

    kubectl get pods

Next, to view what containers are inside that Pod and what images are used to build those containers we run the describe pods command:

    kubectl describe pods

We see here details about the Pod’s container: IP address, the ports used and a list of events related to the lifecycle of the Pod.


Now again, we'll get the Pod name and query that pod directly through the proxy. To get the Pod name and store it in the POD_NAME environment variable:

    export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
    echo Name of the Pod: $POD_NAME

To see the output of our application, run a curl request.

        curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/
        
The url is the route to the API of the Pod.


## View the container logs
Anything that the application would normally send to STDOUT becomes logs for the container within the Pod. We can retrieve these logs using the kubectl logs command:

    kubectl logs $POD_NAME

Note: We don’t need to specify the container name, because we only have one container inside the pod.

start a bash session in the Pod’s container:

    kubectl exec -ti $POD_NAME -- bash

We have now an open console on the container where we run our NodeJS application. The source code of the app is in the server.js file:


You can check that the application is up by running a curl command:

    curl localhost:8080

Note: here we used localhost because we executed the command inside the NodeJS Pod. If you cannot connect to localhost:8080, check to make sure you have run the kubectl exec command and are launching the command from within the Pod


## Create a new service

    kubectl get services
    
We have a Service called kubernetes that is created by default when minikube starts the cluster. To create a new service and expose it to external traffic we’ll use the expose command with NodePort as parameter (minikube does not support the LoadBalancer option yet).

        kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
        
We have now a running Service called kubernetes-bootcamp. Here we see that the Service received a unique cluster-IP, an internal port and an external-IP (the IP of the Node).

To find out what port was opened externally (by the NodePort option) we’ll run the describe service command:

    kubectl describe services/kubernetes-bootcamp
    
Create an environment variable called NODE_PORT that has the value of the Node port assigned:

export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT

Now we can test that the app is exposed outside of the cluster using curl, the IP of the Node and the externally exposed port:

curl $(minikube ip):$NODE_PORT

## Labels

Let’s use this label to query our list of Pods. We’ll use the kubectl get pods command with -l as a parameter, followed by the label values:

    kubectl get pods -l app=kubernetes-bootcamp

You can do the same to list the existing services:

    kubectl get services -l app=kubernetes-bootcamp
And we get a response from the server. The Service is exposed.


### To apply a new label we use the label command followed by the object type, object name and the new label:

    kubectl label pods $POD_NAME version=v1
    
## Deleting a service

To delete Services you can use the delete service command. Labels can be used also here:

    kubectl delete service -l app=kubernetes-bootcamp


## Deployment

- ``` k scale deployment deploy --replicas 4``` change count of replicas in deployment 
- ``` autoscale deployment deploy --min=4 --max=6 --cpu-percent=80  ``` 
- ```k rollout undo  deployment/deploy ```    return to last version of image
- ```k set image deployment/deploy k8sphp=adv4000/k8sphp:version2 --record. ```   set another version of image
- ```k rollout undo deployment/deploy --to-revision=4```     change to some revision
- ``` k rollout history  deployment/deploy```      |    view versions of revisions
- ```k rollout restart deployment/deploy```      update if image version = latest and you need to update
- ```k apply -f deployment-1-simple.yaml ```       | create deployment from yaml file 


## Services

- ```k expose deployment deployname --type=ClusterIP --port 80``` - create service
- ```kubectl get services ``` - view services
- 
