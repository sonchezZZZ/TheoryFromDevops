# HA mode

The Helm chart may be run in high availability (HA) mode. This installs three Vault servers with an existing Consul storage backend. It is suggested that Consul is installed via the Consul Helm chart.

Install the latest Vault Helm chart in HA mode.

    $ helm install vault hashicorp/vault \
        --set "server.ha.enabled=true"

 kubectl exec -ti hashicorp-vault-0 -- vault operator init --key-shares=1 --key-threshold=1

kubectl exec vault-0 -- vault operator unseal ZEqukdOIfRwII9b3vfg3lGkLZBuKI0A+dRtUUFeSX5Q=

kubectl exec vault-0 -- vault login s.qFTuOIadjknPDDrBglbosv4B

kubectl exec -it vault-0 -- /bin/sh    

### Create secret user/passv 

vault kv put secret/webapp/config username="cluster1-user" password="cluster1-password"

https://learn.hashicorp.com/tutorials/vault/kubernetes-minikube

