## Scale Deployment'a

Давайте изменим количество реплик Подов: 

```kubectl scale deployment -n lesson15 goapp-deployment --replicas=5```

И сразу посмотрим, сколько у нас стало Подов: 

```kubectl get pods -n lesson15```



## DaemonSet
Возьмем абсолютно реальный пример из жизни. Есть База Данных ElasticSearch, визуальный интерфейс для взаимодействия с этой базой Kibana и сборщик логов Fluentd.

Fluentd деплоится на Ноду и собирает логи, которые Поды пишут в stdout (в поток вывода).

Как нам задеплоить fluentd на все Ноды нашего кластера?  Использовать daemonSet:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-elasticsearch
  namespace: kube-system
  labels:
    k8s-app: fluentd-logging
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
```        
Другие примеры из жизни - k8s-pinger, goldpinger.

 

То есть контроллер ДемонСет поддерживает по одной реплике Пода на каждой из Нод кластера, в этом вся его суть.

## Job
Первый контроллер в Kubernetes. Джоба поднимает под, отрабатывает и помирает до следующего запуска.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl:5.34.0
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
  backoffLimit: 4
```  
Это пример из официальной документации Кубернетеса. Данная Джоба запускает под, который вычитывает 2000 знаков после запятой у числа Пи. Задеплойте Джобу через kubectl apply, дождитесь отработки Пода (статус Completed) и посмотрите на логи:



## CronJob
Если Вам понадобится Джоба, которая должна запускаться по расписанию, используйте механизм CronJob.
