Создаем свой Chart
Теперь сделаем наконец наш Чарт (шаблон), если Вы уже поставили бинарную утилиту Helm, введите в папке lesson2_1 команду:

helm create test-chart
В папке создастся целое дерево для шаблонов:



Удалите serviceaccount.yaml, ingress.yaml, hpa.yaml, _helpers.tpl, папку test, .helmignore, NOTES.txt, чтобы нам ничего не мешало и очистите все файлы, кроме Chart.yaml



Теперь заполним файлы:

deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
  labels:
    app: {{ .Release.Name }}-deployment
spec:
  replicas: {{ .Values.replicas }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:  
      containers:
      - name: web
        image: {{ .Values.image}}
        ports:
        - containerPort: 8080
        env:
          - name: {{ .Values.secret.name }}
            valueFrom:
              secretKeyRef:
                name: {{ .Values.secret.name }}
                key: password
service.yaml

apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-service
spec:
  selector:
    app: {{ .Release.Name }}
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
secret.yaml

apiVersion: v1
kind: Secret
metadata:
  name: {{ .Values.secret.name }}
stringData:
  password: {{ .Values.secret.password }}
values.yaml

image: ksxack/lesson1:v0.2
replicas: 3
secret:
  name: load-secret
  password: loadqwerty
Вы наверняка уже заметили, что мы оставили большинство без изменений, а используя конструкцию {{ }} мы добавили переменные, если конструкция {{ .Values... }}, то значение переменной подставится из файла values.yaml, но есть и Хельмовые переменные в стиле {{ .Release.Name }}.

Интереса ради попробуйте вынести еще что-нибудь в values.yaml, например port Сервиса, а потом давайте уже установим наш Хельм-релиз:

helm install my-helm-release  test-chart -n tst-namespace -f test-chart/values.yaml

LAST DEPLOYED: Sat Jun 19 10:29:58 2021
NAMESPACE: tst-namespace
STATUS: deployed
REVISION: 1
TEST SUITE: None
Разберем команду helm Install - запуск установки, my-helm-release - имя релиза ( {{ .Release.Name }} ), test-chart - папка с самим Чартом, -f test-chart/values.yaml - мы могли не писать, так как эти значения используются в чарте по дефолту. 

Вы можете удалить релиз командой helm uninstall my-helm-release

Создать файл dev.yaml

replicas: 1
secret:
  name: dev-secret
  password: devqwerty
И установить командой 

helm install my-dev-release  test-chart -n dev-namespace -f test-chart/dev.yaml
Так как мы указали количество реплик в dev.yaml равное 1, дефолтное значение в values.yaml (3 реплик) будет переопредлено.

Последнее, что мы сделаем на этом шаге - соберем архив с Чартом:

helm package test-chart 
Он пригодится Вам, если в Вашей компании будет ChartMuseum в стиле Harbor.
