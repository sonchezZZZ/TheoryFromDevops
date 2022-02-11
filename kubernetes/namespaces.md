# Namespaces

## Create namespace from cli

         kubectl create namespace <insert-namespace-name-here>

## Create namespace from yml

1. Create a new YAML file called my-namespace.yaml with the contents:

          apiVersion: v1
          kind: Namespace
          metadata:
            name: <insert-namespace-name-here>
            
2. Then run:

          kubectl create -f ./my-namespace.yaml            
