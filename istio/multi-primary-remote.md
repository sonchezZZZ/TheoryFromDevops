# Primary cluster

## Set label about network

## Create istioOperator

## Generate eastwest-gateway 

    samples/multicluster/gen-eastwest-gateway.sh \
        --mesh mesh1 --cluster cluster1 --network network1 | \
        istioctl --context="${CTX_CLUSTER1}" install -y -f -

## Expose the control plane in cluster

    kubectl apply --context="${CTX_CLUSTER1}" -n istio-system -f \
        ../samples/multicluster/expose-istiod.yaml


## Expose services in cluster1

    kubectl --context="${CTX_CLUSTER1}" apply -n istio-system -f \
      samples/multicluster/expose-services.yaml
