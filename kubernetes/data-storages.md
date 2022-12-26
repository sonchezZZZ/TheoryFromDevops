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

Persistent Volume Claim
ersistentVolumeClaim (PVC) есть не что иное как запрос к Persistent Volumes на хранение от пользователя. Это аналог создания Pod на ноде. Поды могут запрашивать определенные ресурсы ноды, то же самое делает и PVC. Основные параметры запроса:

объем pvc
тип доступа
Типы доступа у PVC могут быть следующие:

ReadWriteOnce – том может быть смонтирован на чтение и запись к одному поду.
ReadOnlyMany – том может быть смонтирован на много подов в режиме только чтения.
ReadWriteMany – том может быть смонтирован к множеству подов в режиме чтения и записи.
Ограничение на тип доступа может налагаться типом самого хранилища. К примеру, хранилище RBD или iSCSI не поддерживают доступ в режиме ReadWriteMany.

Один PV может использоваться только одним PVС. К примеру, если у вас есть 3 PV по 50, 100 и 150 гб. Приходят 3 PVC каждый по 50 гб. Первому будет отдано PV на 50 гб, второму на 100 гб, третьему на 150 гб, несмотря на то, что второму и третьему было бы достаточно и 50 гб. Но если PV на 50 гб нет, то будет отдано на 100 или 150, так как они тоже удовлетворяют запросу. И больше никто с PV на 150 гб работать не сможет, несмотря на то, что там еще есть свободное место.

Из-за этого нюанса, нужно внимательно следить за доступными томами и запросами к ним. В основном это делается не вручную, а автоматически с помощью PV Provisioners. В момент запроса pvc через api кластера автоматически формируется запрос к storage provider. На основе этого запроса хранилище создает необходимый PV и он подключается к поду в соответствии с запросом.


Данный тип ресурса позволяет хранить персистентные данные ваших приложений. Для того, чтобы использовать PVC, Вам необходимо, чтобы в кластере был реализован интерфейс CSI (Container Storage Interface) администратором кластера. PVC своего рода запрос необходимого постоянного тома (диска). Вам, как пользователю, не обязательно знать какой это будет диск и откуда, нужно лишь указать сколько дискового пространства Вам необходимо для использования. После размещения PVC в кластере, будет создан автоматически ресурс PV (Persistent Volume), который ссылается на конкретный физический том, и будет налажена связь между данными PVC и PV. В некоторых кластерах за создание PV отвечает администратор, как на картинке ниже, однако в последнее время все чаще этим администратором является драйвер, который делает все автоматически. 

![image](https://user-images.githubusercontent.com/79608549/209567143-5e57aede-2db4-4fea-8df3-7bd7e990c0b8.png)

Чтобы создать PVC, необходимо написать следующий манифест:

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: "default"  # default используется по умолчанию, можно прописать тот класс, 
  resources:                   # который сообщит Вам администратор
    requests:
      storage: 30Gi
Остается примонтировать наш PVC к нашему Поду:

spec:
  containers:
    - name: web
      image: ksxack/lesson1:v0.2
      ports:
        - containerPort: 8080
      volumeMounts:
      - mountPath: "/data"
        name: my-volume
  volumes:
    - name: my-volume
      persistentVolumeClaim:
        claimName: my-pvc
