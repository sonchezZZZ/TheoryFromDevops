# 1. Create certificates

    # SERVICE is the name of the Vault service in Kubernetes.
    export SERVICE=vault
    # NAMESPACE where the Vault service is running.
    export NAMESPACE=vault
    # SECRET_NAME to create in the Kubernetes secrets store.
    export SECRET_NAME=vault-tls
    # TMPDIR is a temporary working directory.
    export TMPDIR=/tmp
    

Create the Private Key based on our CSR.

```openssl genrsa -out ${TMPDIR}/vault.key 4096```

## Create configuration for certificate

    cat <<EOF >${TMPDIR}/csr.conf
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    extendedKeyUsage = serverAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = vault
    DNS.2 = vault.vault
    DNS.3 = vault.vault.svc
    DNS.4 = vault.vault.svc.cluster.local
    DNS.5 = *.vault-internal
    DNS.6 = *.sofiiacluster2-dns-007c1e0c.hcp.eastus.azmk8s.io
    DNS.7 = *.sofiiacluster-dns-40532e22.hcp.eastus.azmk8s.io
    DNS.8 = sofiiacluster-dns-40532e22.hcp.eastus.azmk8s.io
    DNS.9 = sofiiacluster2-dns-007c1e0c.hcp.eastus.azmk8s.io
    DNS.10 = *.vault-primary-internal
    DNS.11 = *.vault-secondary-internal
    DNS.12 = assareh-vault-pri.eastus.cloudapp.azure.com
    DNS.13 = assareh-vault-sec.eastus.cloudapp.azure.com
    IP.1 = 127.0.0.1
    EOF    


Now lets create server.csr with our csr.conf and private key

    openssl req -new -key ${TMPDIR}/vault.key -subj "/CN=${SERVICE}.${NAMESPACE}.svc" -out ${TMPDIR}/server.csr -config ${TMPDIR}/csr.conf




Create Kubernetes certificate Resource

    export CSR_NAME=vault-csr
        cat <<EOF >${TMPDIR}/csr.yaml
    apiVersion: certificates.k8s.io/v1beta1
    kind: CertificateSigningRequest
    metadata:
      name: ${CSR_NAME}
    spec:
      groups:
      - system:authenticated
      request: $(cat ${TMPDIR}/server.csr | base64 | tr -d '\n')
      usages:
      - digital signature
      - key encipherment
      - server auth
    EOF
    
Lets apply it and approve it and export our signed certificate

```kubectl create -f ${TMPDIR}/csr.yaml```

## Approve the Self-Signed Certificate by K8S CA

```kubectl certificate approve ${CSR_NAME} ```

# 2. Store key, cert, and Kubernetes CA into Kubernetes secrets store

```serverCert=$(kubectl get csr ${CSR_NAME} -o jsonpath='{.status.certificate}')```

```echo "${serverCert}" | openssl base64 -d -A -out ${TMPDIR}/vault.crt```

Export out CA Cert (the one who signed the certificate for full chain)

```kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 -d > ${TMPDIR}/vault.ca```

Finally we can create secret with public private and ca certificates for out vault cluster to use later.

    kubectl create namespace ${NAMESPACE}

    kubectl create secret generic ${SECRET_NAME} \
        --namespace ${NAMESPACE} \
        --from-file=vault.key=${TMPDIR}/vault.key \
        --from-file=vault.crt=${TMPDIR}/vault.crt \
        --from-file=vault.ca=${TMPDIR}/vault.ca

# 3 Install vault in kubernetes 

- [install primary vault](../Hashicorp-vault/create_primary_vault.md)
- [install secondary vault](../Hashicorp-vault/create_secondary_vault.md)     
