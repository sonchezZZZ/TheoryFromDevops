# HA mode

The Helm chart may be run in high availability (HA) mode. This installs three Vault servers with an existing Consul storage backend. It is suggested that Consul is installed via the Consul Helm chart.

Install the latest Vault Helm chart in HA mode.

    $ helm install vault hashicorp/vault \
        --set "server.ha.enabled=true"

 kubectl exec -ti hashicorp-vault-0 -- vault operator init --key-shares=1 --key-threshold=1

kubectl exec vault-0 -- vault operator unseal ZEqukdOIfRwII9b3vfg3lGkLZBuKI0A+dRtUUFeSX5Q=

kubectl exec vault-0 -- vault login s.qFTuOIadjknPDDrBglbosv4B

kubectl exec -it vault-0 -- /bin/sh   

kubectl exec -ti vault-1 -- vault operator raft join http://vault-0.vault-internal:8200 

### Create secret user/passv 

vault kv put secret/webapp/config username="cluster1-user" password="cluster1-password"

https://learn.hashicorp.com/tutorials/vault/kubernetes-minikube


## Kubernetes license

secret=$(cat 1931d1f4-bdfd-6881-f3f5-19349374841f.hclic)

kubectl create secret generic vault-ent-license --from-literal="license=${secret}"

# Configure Kubernetes authentication

    JWT=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

    # Address of Kubernetes itself as viewed from inside a running pod
    KUBERNETES_HOST=https://${KUBERNETES_PORT_443_TCP_ADDR}:443

    # Kubernetes internal CA
    KUBERNETES_CA_CERT=$(cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt)

Exec into the Vault pod:

```kubectl exec -it vault-0 /bin/sh```

    vault write auth/kubernetes/config \
       token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
       kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
       kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
