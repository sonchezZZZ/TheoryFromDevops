## Requests, Limits

```yaml
containers:
- name: app
  image: ksxack/lesson1:v0.2
  resources:
    requests:
      memory: "100Mi"
      cpu: "200m"
    limits:
      memory: "150Mi"
      cpu: "300m"
```


**Реквесты** - это то количество ресурсов, которое Под занимает на Ноде (воркере). 

Например, если у Вас Нода на 1000 миллиядер CPU, 3 микросервиса, у которых в реквестах стоит по 400 миллиядер **CPU** - третий микросервис ни при каких условиях не встанет на эту Ноду, Кубернетес (scheduler) поставит третий микросервис на следующую Ноду. Можно представить себе стол, на котором теснятся 2 ноутбука, а Вы хотите положить третий - придется класть на второй стол.

![image](https://user-images.githubusercontent.com/79608549/209567684-85fa2187-9a46-4c11-a6e7-7586ea9c03df.png)


## Лимиты.

Приложения в Подах могут в моменте давать больше нагрузки, чем Вы ожидаете, например Java любит во время старта приложения выжирать весь CPU, который только может. Если Ваше приложение стандартно кушает 400mi CPU, но на старте хочет кушать 2000mi, а Вы поставите лимит 400mi, оно будет подниматься минут 10. Поэтому Вы можете сделать реквест 400mi, а лимит 1000mi, чтобы на старте приложение поднялось за 2-3 минуты. Стоит отметить, что если приложение дойдет до лимита памяти - его убьет OOM Killer. Если приложение дойдет до лимита CPU - оно будет Троттлить (это снижение частоты процессора, чтиво). Однако посыл в том, что Kubernetes вообще никак не мешает приложению выходить за рамки реквестов.

Здесь вытекает предположение: что если у меня Нода на 1000mi CPU, я поставил 2 микросервиса, с реквестом на 400mi CPU, лимитом на 1000mi CPU. Если у меня они оба упадут или упадет Нода, и они переподнимутся и начнут на старте выжирать свой максимум? То есть будут кушать 2000mi CPU, когда на Ноде всего 1000mi. Наверняка Ноде станет плохо, и возможно она даже снова упадет, Поды уедут на другую Ноду, убьют ее и далее по кластеру. - Ответ: маловероятно.



**В Кубернетесе есть такое понятие как QoS (Quality of Service). Существует три типа QoS:**

- Best Effort - такой класс присваивается, когда Вы вообще не указываете реквесты и лимиты;
- Burstable - данный класс будет присвоен, если лимиты и реквесты отличаются;
- Guaranted - когда лимиты и реквесты равны друг-другу.


Важно видеть разницу между этими классами, до нее можно дойти логически. Если у нас реквесты и лимиты равны друг-другу, то Под при любых обстоятельствах получит те ресурсы, которые мы ему предоставили, поэтому и класс Guaranted. Если у нас на ноде стоит Под с request=limit=800 mi, и второй Под без указания ресурсов, то при ситуации, когда Pod2 кушает 300mi, а Pod1 начал расти к 800, Кубернетес беспощадно будет душить Pod2 по ресурсам. Оно и логично - ведь ресурсы Pod2 не заказывал.


Аналогично происходит и с классом Burstable. По приоритету идут так Guaranted > Burstable > Best Effort.

> Note! 
Существует много холиваров на счет того, ставить ли лимиты или, например, нельзя ограничивать приложения в Продакшн средах. Наша позиция - ставить. А чтобы защитить себя от исчерпания выделенных Поду ресурсов, можно настроить автомасштабирование.

## Пробы

livenessProbe

Если Вы работаете хотя бы пол года в IT,  Вы точно знаете, что большинство проблем решается перезагрузкой. 

**liveness** - проба позволяет Кубернетусу делать Health-check'и и при непрохождении определенного в описании Пробы количества проверок Kubernetes перезагрузит контейнер в Поде.

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: my-pod
  name: my-pod-http
spec:
  containers:
  - name: containername
    image: k8s.gcr.io/liveness
    args:
    - /server
    livenessProbe:
      httpGet:
        path: /healthz
        port: 8080
        httpHeaders:
        - name: Custom-Header
          value: Awesome
      initialDelaySeconds: 3
      periodSeconds: 2
```

В данном случае, если сервис не отвечает на **Health-check**, или отвечает не 200-ым или 400-ым кодом ответа, он провалит одну из 3 (по умолчанию) Проверок. 

- initialDelaySeconds: 3 - означает, что после запуска Пода и перед первой Проверкой пройдет 3 секунды. По умолчанию - 0 секунд.
- periodSeconds: 2 - означает, что проверки будут происходить каждый 2 секунды. По умолчанию - 10 секунд.
- failureThreshold:  количество повторных Проверок перед рестартом. По умолчанию 3
- timeoutSeconds: Количество секунд ожидания ответа на Проверке. По умолчанию 1 секунда. 
- successThreshold: Минимальное количество последовательных проверок, чтобы проба считалась успешной после неудачной. По умолчанию 1. 
Итак, если наше приложение запустилось, поработало пару часов, зависло и совсем не отвечает, оно будет рестартовано спустя 9 секунд.

## readinessProbe

Допустим у Вас деплоймент с 3 репликами Подов, на один из Подов попал крупный запрос и он ушел 20 секунд его отрабатывать, лучшим решением будет перенаправлять трафик на другие Поды, пока загруженный не отработает. Так работает readinessProbe, в случае ее непрохождение, Kubernetes Service не будет посылать запросы на Под.

```yaml
readinessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 5
startupProbe
```

Мы периодически сталкиваемся с кейсами, когда приложение стартует довольно долго. Например, мы дали ему мало CPU (так как в покое ему много и не надо), и оно запускается 5 минут, в результате чего не проходит все readiness/liveness проверки и попадает в вечный ребут (CrashLoop). startupProbe  решает эту проблему, ведь если она настроена, liveness и readiness Пробы не будут отрабатывать, пока не завершится работа Стартап Пробы.

```yaml
startupProbe:
  httpGet:
    path: /healthz
    port: liveness-port
  failureThreshold: 30
  periodSeconds: 10
```

> Note! 
Всегда используйте Пробы. Если Вы администратор, проговаривайте настройку Проб с разрабочтиками приложений. Если Ваш микросервис начнет тупить, Кубернетес должен об этом как-то узнать, описать Пробы намного легче, чем часами выяснять потом, на чьей стороне недостаток. 



## Horizontal Pod Autoscaler

Горизонтальное масштабирование означает добавление новых реплик. **HPA** - отдельный ресурс в Кубернетес, который позволяет масштабировать приложение 

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80
```

В данном примере, Делпойменту php-apache присуждается минимальное количество реплик - 1, максимальное - 5, и в случае, если CPU у одного из Подов дойдет до 80% от реквеста, то HPA добавит еще одну реплику.
