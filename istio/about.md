# Istio with minikube 

1.  `` minikube start --cpus 6 --memory 8192`` - start minikube 

2. export PATH=$PATH:~/istio1...
3. ``istioctl ``  - check if it works



## Configs for running injection

1. ``kubectl label namespace default istio-injection=enabled`` 
2. Check if lable  was added ``k get ns default --show-labels``
3. delete deployments and apply again  (if some running before)


## Programs for istio 

- ``k apply -f istio1.13.1/samples/addons``

- **Graffana** - data visualization tool for metrics data and **Prometheus** - monitoring servers, cpu,pods 
- **Jaeger-collection** - visualization for tracing, **tracing** - tracing microservice request, and whole chain of requests of microservices
- **zipkin** - alternative to jaeger 
- **Kiali ** - data visualization features  (includes monitoring data in the tracing data)


## Create from file using istio command 

``kubectl create -f < (istioctl kube-inject -f bookinfo.yaml)``


## How to enable deployments and services for the data visualization to work 

1. Add label ****app**  in the deployment and service metadata  

          spec:
            selector:
              matchLabels:
                  app: someApp
                  
              template:
                metadata:
                  labels:
                    app: someApp


## Kinds of ISTIO resources 

-**gateway** ()
