Создание PV и PVC
В данном модуле мы воспользуемся сценарием Катакода, чтобы поднять Statefull сервис, то есть сервис с неким состоянием/хранимыми процедурами, которые нельзя терять. Отличный пример statefull приложения - База Данных.

Мы уже знакомы с терминами Persistent Volume (ссылка на диск)  и Persistent Volume Claim (запрос на создание постоянного тома). Для того, чтобы реализовать данные ресурсы, Катакода предлагает нам поднять NFS - сервер в Докере.

docker run -d --net=host \
     --privileged --name nfs-server \
     katacoda/contained-nfs-server:centos7 \
     /exports/data-0001 /exports/data-0002
Убедимся, что сервер запустился docker ps | grep nfs, а если Вы хотите узнать больше информации про запущенный Контейнер, воспользуйтесь командой docker inspect <CONTAINER_ID>

Далее создадим два PV и просмотрим содержимое манифестов:

kubectl create -f nfs-0001.yaml

kubectl create -f nfs-0002.yaml

cat nfs-0001.yaml nfs-0002.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-0001
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: 172.17.0.44
    path: /exports/data-0001
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-0002
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: 172.17.0.44
    path: /exports/data-0002
Здесь мы можем наблюдать объемы наших дисков, их имена, виды доступа и ReclaimPolicy (политика возврата).

PersistentVolume может иметь следующие ReclaimPolicy: Retain, Recycle и Delete. Для динамически создаваемых PV, по дефолту указывается политика "Delete". Это означает, что динамически созданный PV будет автоматически удален при удалении PVC. Такое поведение может Вас не устраивать. Если Вам необходимо удерживать данные даже при удалении PVC, тогда стоит указывать политику "Retain" . Политика "Recycle" полностью очищает PV, но не удаляет его (делает rm -rf /thevolume/*), это позволяет вновь обращаться к PV, не пересоздавая его.

Воспользуемся командой kubectl get pv

![image](https://user-images.githubusercontent.com/79608549/209572221-94cb975f-6d12-4cce-a88d-50b3649637c7.png)


Наши PV создались успешно, теперь мы можем объявить PVC:

kubectl create -f pvc-mysql.yaml

kubectl create -f pvc-http.yaml

cat pvc-mysql.yaml pvc-http.yaml

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: claim-mysql
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: claim-http
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
Итак, мы создали два PVC на 3 ГБ и на 1 ГБ, которые автоматически найдут себе PV, информация об этом будет доступна командой:

kubectl get pvc

![image](https://user-images.githubusercontent.com/79608549/209572238-47311ff2-d48d-4729-a06a-b07d15022711.png)


Использование PVC
Теперь, когда у нас есть тома, мы можем примонтировать их к Подам, которым необходимо сохранять информацию при падениях. Создадим такие Поды:

kubectl create -f pod-mysql.yaml

kubectl create -f pod-www.yaml

cat pod-mysql.yaml pod-www.yaml

apiVersion: v1
kind: Pod
metadata:
  name: mysql
  labels:
    name: mysql
spec:
  containers:
  - name: mysql
    image: openshift/mysql-55-centos7
    env:
      - name: MYSQL_ROOT_PASSWORD
        value: yourpassword
      - name: MYSQL_USER
        value: wp_user
      - name: MYSQL_PASSWORD
        value: wp_pass
      - name: MYSQL_DATABASE
        value: wp_db
    ports:
      - containerPort: 3306
        name: mysql
    volumeMounts:
      - name: mysql-persistent-storage
        mountPath: /var/lib/mysql/data
  volumes:
    - name: mysql-persistent-storage
      persistentVolumeClaim:
        claimName: claim-mysql
Тут все просто: в уже привычном нам манифесте Пода объявляется Volume - это ссылка на то хранилище, которое будет использоваться, а также volumeMount - привязывание этого хранилища к определенной директории Контейнера.

Убедимся, что Поды стартовали:

kubectl get pods

![image](https://user-images.githubusercontent.com/79608549/209572267-f640b72f-2bb0-4b18-8659-f89744f0c61b.png)

Информацию о монтированиях в Подах можно получить с помощью describe

kubectl describe pod mysql

![image](https://user-images.githubusercontent.com/79608549/209572288-f14de733-886b-449c-99ff-138cf9aad392.png)

Проверяем механизм
Итак, мы создали NFS-сервер, PV, PVC и Pod, к которому примонтировали PVC. Теперь мы можем записать некоторые данные на NFS-сервер в директорию /exports/data-0001/: 

docker exec -it nfs-server bash -c "echo 'Hello World' > /exports/data-0001/index.html"

ip=$(kubectl get pod www -o yaml |grep podIP | awk '{split($0,a,":"); print a[2]}'); echo $ip

curl $ip
![image](https://user-images.githubusercontent.com/79608549/209572311-19c07321-ebf8-4e50-a7de-d294f740f8ab.png)

Изменив данные, мы можем убедиться, что ответ нашего Пода www зависит от содержимого в /exports/data-0001/index.html

docker exec -it nfs-server bash -c "echo 'Hello NFS World' > /exports/data-0001/index.html"

curl $ip
![image](https://user-images.githubusercontent.com/79608549/209572334-6f418ecf-406f-41c8-9288-8c3b83e6e0be.png)

Теперь мы можем убедиться, что информация в нашем Поде защищена от падений Пода:

kubectl delete pod www

kubectl create -f pod-www2.yaml

ip=$(kubectl get pod www2 -o yaml |grep podIP | awk '{split($0,a,":"); print a[2]}'); curl $ip
![image](https://user-images.githubusercontent.com/79608549/209572350-cac5eb48-fef5-4437-8cd3-9ef57fab8ea0.png)

