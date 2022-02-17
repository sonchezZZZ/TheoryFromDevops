# Istio with minikube 

1.  `` minikube start --cpus 6 --memory 8192`` - start minikube 

2. export PATH=$PATH:~/istio1...
3. ``istioctl ``  - check if it works



## Configs for running injection

1. ``kubectl label namespace default istio-injection=enabled`` 
2. Check if lable  was added ``k get ns default --show-labels``
3. delete deployments and apply again  (if some running before)

``or``

1. Find Values for profile which will be used
2. In default -> values.yaml ->`` enableNamespacesByDefault: true``


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

2. Create Cluster Service for deployment 

          ---
          apiVersion: v1
          kind: Service
          metadata:
            name: echo-server-v1
            labels:
              version: v1
          spec:
            type: ClusterIP
            ports:
            - name: echo-port
              port: 80
              targetPort: 8080
            selector:
              app: echo-server
              version: v1

3. Create gateway for application

          apiVersion: networking.istio.io/v1alpha3
          kind: Gateway
          metadata:
            name: gateway
          spec:
            selector:
              istio: ingressgateway
            servers:
              - port:
                  number: 80
                  name: http
                  protocol: HTTP
                hosts:
                  - '*'  

3. Create Virtualservice for application

          ---
          apiVersion: networking.istio.io/v1alpha3
          kind: VirtualService                      # Virtual Service
          metadata:
            name: echo-service-ingress              # some name
          spec:
            hosts:
            - '*'                                   # host from which user will be come in
            gateways:
            - echo-gateway                          # gateway name
            http: 
              - match:                          # if matching 
                - headers:                          # in header
                    host:                           # host consist
                      exact: echo-server-v1          # such text
                route:                          # then
                - destination:
                    host: echo-server-v1           # go to cluster service with such name
              - route:                          # else
                - destination:
                    host: echo-server-v2           # go to cluster service with such name 

## Kinds of ISTIO resources 

-**gateway** ()


# Control Plane

- 
