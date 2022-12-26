Helm
Хельм - это отличный инструмент для шаблонизации наших манифестов. Воспользуйтесь официальным сайтом и скачайте бинарную утилиту Хельм.

Давайте представим, что у нас есть манифест деплоймента с Секретом, и мы собираемся разворачивать Деплоймент на трех стендах: DEV, LOAD, PRODUCTION. 

apiVersion: apps/v1
kind: Deployment
metadata:
  name: goapp-deployment
  namespace: dev
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
    spec:        
      containers:
      - name: web
        image: ksxack/lesson1:v0.2
        ports:
        - containerPort: 8080
        env:
          - name: SECRETENV
            valueFrom:
            secretKeyRef:
              name: dev-secret
              key: password
На DEV-стенде у нас секрет с паролем dev-secret, на LOAD - load-secret, на Проде - prod-secret. Плюс меняются неймспейсы.

С текущими знаниями мы создадим три многострочных манифеста Деплоймента и будем вынуждены править их и применять, выходит, что набор информации в файлах избыточен, это не очень удобно, да и ошибиться проще простого.

Используя Helm, мы можем создать Шаблон нашего Деплоймента, и деплоить наши приложения используя двухстрочные файлы values.yaml

namespace: load
secretName: load-secret
Более того, в Хельм-чарте, можно также создавать не только деплоймент, но и все необходимые нам ресурсы, сервис, секреты и т.п.
