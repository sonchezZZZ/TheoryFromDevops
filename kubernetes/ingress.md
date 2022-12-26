Ingress
Помните, как мы объявляли Сервис типа LoadBalancer? Для каждого Сервиса было необходимо выделять отдельный IP-адрес, что провоцирует риск исчерпания адресов в подсети. Ingress - это удобный механизм, позволяющий обойти эту проблему. Более того, используя Ingress мы можем задать единую точку входа в наш кластер. Ingress позволяет нам назначить для каждого Сервиса свой URL, доступный вне кластера.

Для того, чтобы использовать Ingress, в кластере должен быть настроен Ingress Controller. В отличие от таких контроллеров, как Deployment, DaemonSet, Job и прочих, Ingress Controller не располагается внутри kube-conroller-manager, его надо устанавливать отдельно, например, используя публичный Хельм Чарт.

Давайте разберемся в терминологии, есть Ingress Controller - задеплоенный в отдельном Неймспейсе ресурс, который как правило порождает Поды ingress-nginx, через них и осуществляется вся балансировка. А также есть ресурс Ingress, он располагается в том же Неймспейсе, где находится Под и Сервис, в данном ресурсе описываются правила маршрутизации трафика (ingress-rules).

![image](https://user-images.githubusercontent.com/79608549/209571112-6212258a-434a-484d-bd9b-510cd4e46c3e.png)


С точки зрения пользователя взаимодействие выглядит следующим образом:

1. Вы разворачиваете Деплоймент и Сервис;

2. Вы создаете ресурс Ингресс;

3. Поды Вашего Деплоймента становятся доступны не только через IP-адрес Сервиса, но и по внешнему URL-адресу.

Пример манифеста для описания Ингресс ресурса:



apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-fanout-example
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /foo
        pathType: Prefix
        backend:
          service:
            name: service1
            port:
              number: 4200
      - path: /bar
        pathType: Prefix
        backend:
          service:
            name: service2
            port:
              number: 8080

Данный манифест откроет Вам такую схему взаимодействия:

![image](https://user-images.githubusercontent.com/79608549/209571124-330899e1-3e50-40bf-9968-a9cbe34380ef.png)


Однако Ингресс предоставляет нам гораздо больше вариативности, например мы можем иметь wildcard домен *.production.myCompany, и создавать Ингрессы с URL вида https://grafana.production.myCompany/ (для доступа к Сервису Графаны), https://kibana.production.myCompany/ (для доступа к Сервису Кибаны).

 

Стоит учесть, что по дефолту Ингресс Контроллер позволяет Вам работать с HTTP и HTTPS трафиком, так что у Вас не получится настроить доступ к БД, используя Ингресс без дополнительных настроек Ингресс Контроллера.

Практика с Ingress
Создаем ресурс Ингресс

Создав ресурс Ингресс мы получим нужные нам правила маршрутизации трафика. Давайте посмотрим на манифест, предлагаемый Катакодой командой cat ingress-rules.yaml

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: webapp-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: my.kubernetes.example
    http:
      paths:
      - path: /webapp1
        backend:
          serviceName: webapp1-svc
          servicePort: 80
      - path: /webapp2
        backend:
          serviceName: webapp2-svc
          servicePort: 80
      - backend:
          serviceName: webapp3-svc
          servicePort: 80
Итак, у нас есть хост my.kubernetes.example , а обращаясь по URL my.kubernetes.example/webapp1 Ингресс Контроллер перенаправит нас на Сервис webapp1-svc , который имеет селектор app=webapp1. Под подконтрольный Деплойменту webapp1 имеет лейбл app=webapp1, поэтому траффик, попавший на Ингресс, попадет на Под.

Итак, создадим ресурс Ингресс kubectl create -f ingress-rules.yaml и убедимся, что команда отработала успешно kubectl get ing
