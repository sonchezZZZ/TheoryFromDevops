

# Create certificates

1. Plug in CA Certificates
2. Custom CA Integration using Kubernetes CSR
3. Istio DNS Certificate Management

## Plug in CA Certificates

1. ``mkdir -p certs``
1. ``pushd certs``
2. ``make -f ../tools/certs/Makefile.selfsigned.mk root-ca`` - generate root certificate
3. ``make -f ../tools/certs/Makefile.selfsigned.mk cluster1-cacerts`` - generate for cluster1
4. ``make -f ../tools/certs/Makefile.selfsigned.mk cluster2-cacerts`` - generate for cluster2
5. ``kubectl create namespace istio-system`` - in first cluster
6.``kubectl create namespace istio-system`` - in second cluster
7. 
 
        kubectl create secret generic cacerts -n istio-system \
            --from-file=cluster1/ca-cert.pem \
            --from-file=cluster1/ca-key.pem \
            --from-file=cluster1/root-cert.pem \
            --from-file=cluster1/cert-chain.pem
            
  8. for second cluster secret


         kubectl create secret generic cacerts -n istio-system \
                  --from-file=cluster2/ca-cert.pem \
                  --from-file=cluster2/ca-key.pem \
                  --from-file=cluster2/root-cert.pem \
                  --from-file=cluster2/cert-chain.pem
                  
 9. Deploy the httpbin and sleep sample services.

         kubectl create ns foo
         kubectl apply -f <(istioctl kube-inject -f samples/httpbin/httpbin.yaml) -n foo
         kubectl apply -f <(istioctl kube-inject -f samples/sleep/sleep.yaml) -n foo

10. Deploy a policy for workloads in the foo namespace to only accept mutual TLS traffic.

           kubectl apply -n foo -f - <<EOF
          apiVersion: security.istio.io/v1beta1
          kind: PeerAuthentication
          metadata:
            name: "default"
          spec:
            mtls:
              mode: STRICT
          EOF

                 
