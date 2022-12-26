Secrets
Прописывать конфиденциальные данные на уровне Докер-образа может быть плохим решением. Представьте, что Ваш сервис подключается к другой системе, используя логин и пароль. Вдруг вы захотели перенести приложение на другой стенд (например, с DEV на LOAD), и на другом стенде Вам нужен уже другой пароль - в таком случае, Вам придется пересобирать Докер-образ заново, и по такой схеме, на Production у Вас попадет не протестированный образ.

Kubernetes позволяет хранить Вам такие данные с помощью ресурса Secrets:

apiVersion: v1
kind: Secret
metadata:
  name: first-secret
  namespace: lesson16
stringData:
  password: qwerty
Использование Секретов в качестве переменной окружения

apiVersion: apps/v1
kind: Deployment
metadata:
  name: goapp-deployment
  namespace: lesson16
  labels:
    app: goapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: goapp
  template:
    metadata:
      labels:
        app: goapp
    spec:         ## В последующих примерах я буду оставлять манифест, начиная со spec.template.spec
      containers:
      - name: web
        image: ksxack/lesson1:v0.2
        ports:
        - containerPort: 8080
        env:
          - name: SECRETENV
            valueFrom:
              secretKeyRef:
                name: first-secret
                key: password
Запись Secrets в файлы в контейнерах

spec:
  containers:
    - name: web
      image: ksxack/lesson1:v0.2
      ports:
        - containerPort: 8080
      volumeMounts:                      # Здесь описано монтирование volume'а к контейнеру
        - name: secret-volume
          mountPath: "/usr/secrets/"
          readOnly: true
  volumes:                               # Здесь описан сам volume (том)
    - name: secret-volume
      secret:
        secretName: first-secret
        
        ConfigMap
Это основной ресурс для хранения в Кубенетес конфигурационных данных. Его отличие от секрета в том, что в Секретах данные кодируются в base64. Также удобно иметь разные типы ресурсов для разных целей, ведь к ним можно будет предоставить разные доступа.

Как и все виды ресурсов  Кубернетеса, ConfigMap можно создать из yaml-файла:

apiVersion: v1
kind: ConfigMap
metadata:
  name: first-cm
  namespace: lesson16
data:
  config.yaml: |
    colorgood: purple
    colorbad: yellow
Также в ConfigMap можно передавать переменные, как и в Secret, только в незашифрованном виде:

apiVersion: v1
kind: ConfigMap
metadata:
  name: env-cm
  namespace: lesson16
data:
    colorgood: purple
    colorbad: yellow
Назовем наш ConfigMap env-configmap.yaml и задеплоим:

kubectl apply -f env-configmap.yaml
Использование ConfigMap в качестве переменной окружения

spec:
  containers:
    - name: web
      image: ksxack/lesson1:v0.2
      ports:
        - containerPort: 8080
      env:
        - name: COLORGOOD
          valueFrom:
            configMapKeyRef:
              name: env-cm
              key: colorgood
        - name: COLORBAD
          valueFrom:
            configMapKeyRef:
              name: env-cm
              key: colorbad
Монтирование ConfigMap'а в файловую систему

Порою КонфигМапы удобнее создавать из файла:

kubectl create cm test-config -n lesson16 --from-file=root-ca.pem  # Вы можете писать cm вместо configmap
root-ca.pem

Примонтируем КонфигМап к деплойменту: 

spec:
  containers:
    - name: web
      image: ksxack/lesson1:v0.2
      ports:
        - containerPort: 8080
      volumeMounts:
        - name: cm-volume
          mountPath: "/etc/ssl/certs/"
          readOnly: true
  volumes:
    - name: cm-volume
      configMap:
        name: test-config

После по пути /etc/ssl/certs/ окажется файл root-ca.pem

Используя эту возможность можно, например, прокинуть SSL - сертификат в контейнер, не прибегая к его пересборке, однако, чтобы новый КонфигМап примонтировался к файловой системе Пода, Вам придется перезагрузить Под.


EmptyDir
Данный том предназначен для хранения небольших данных, он создается пустым (отсюда и название) на сервере, где лежит Под в оперативной памяти или на диске. EmptyDir будет существовать, пока будет жив его Под. Используйте его, когда Вам нужно выделить немного дополнительного места контейнеру, и Вы не против потерять эти данные. Например, EmptyDir можно использовать для кэширования загруженных файлов. На мой взгляд, EmptyDir справедливо сравнивать с /tmp в Linux.

spec:
  containers:
    - name: web
      image: ksxack/lesson1:v0.2
      ports:
        - containerPort: 8080
      volumeMounts:
        - name: cache-volume
          mountPath: /cache
  volumes:
    - name: cache-volume
      emptyDir: {}
Еще один способ использовать EmptyDir - обмениваться файлами в рамках нескольких контейнеров в одном Поде.
