# RBAC

**Role Based Access Contol** - основной механизм управления доступами в Kubernetes.

## Role 

это совокупность прав, которые впоследствии могут быть привязаны к пользователю. 

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

Например, в данной роли предоставляется доступ к просмотру и выводу Подов.

## RoleBinding

Чтобы привязать эту роль к конкретному пользователю, используйте RoleBinding

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ivanov_aa-reader-pods
  namespace: lesson2
subjects:
- kind: User
  name: ivanov_aa
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

Таким образом мы разрешили пользователю Ivanov_aa смотреть Поды в неймспейсе lesson2.

## ServiceAccount

Если Вам необходимо взаимодействовать с API Kubernetes из Пода, Вам понадобится создать ServiceAccount, разница пользователя и SA в том, что SA существует лишь в рамках неймспейса.  

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: demo-sa
automountServiceAccountToken: false
чтобы дать Сервис Аккаунту права, используйте подобный манифест:

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ivanov_aa-reader-pods
  namespace: lesson2
subjects:
- kind: ServiceAccount
  name: demo-sa
  namespace: lesson2
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```
