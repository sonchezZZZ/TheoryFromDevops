# General command for secret 

```bash
vault secrets list -detailed
```

# K/V version 2

## Get secret

The secret is fully replaced and the version is incremented to 2.

Get the secret defined at the path secret/customer/acme.

```bash
 vault kv get secret/customer/acme
```
New in Vault 1.11.0: The following command is equivalent to the above command.

```bash
 vault kv get -mount=secret customer/acme
```
