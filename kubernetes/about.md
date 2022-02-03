The instance is running inside a Docker container on your node.

Pods that are running inside Kubernetes are running on a private, isolated network. By default they are visible from other pods and services within the same kubernetes cluster, but not outside that network. When we use kubectl, we're interacting through an API endpoint to communicate with our application.

We will cover other options on how to expose your application outside the kubernetes cluster

Под — это абстрактный объект Kubernetes, представляющий собой группу из одного или нескольких контейнеров приложения (например, Docker или rkt) и совместно используемых ресурсов для этих контейнеров. Ресурсами могут быть:

Общее хранилище (тома)
Сеть (уникальный IP-адрес кластера)
Информация по выполнению каждого контейнера (версия образа контейнера или используемые номера портов)

Под представляет специфичный для приложения "логический хост" и может содержать разные контейнеры приложений, которые в общем и целом тесно связаны. Например, в поде может размещаться как контейнер с приложением на Node.js, так и другой контейнер, который использует данные от веб-сервера Node.js. Все контейнеры в поде имеют одни и те же IP-адрес и пространство порта, выполняющиеся в общем контексте на одном и том же узле.

Поды — неделимая единица в платформе Kubernetes. При создании развёртывания в Kubernetes, создаются поды с контейнерами внутри (в отличие от непосредственного создания контейнеров). Каждый Pod-объект связан с узлом, на котором он размещён, и остаётся там до окончания работы (согласно стратегии перезапуска) либо удаления. В случае неисправности узла такой же под будет распределён на другие доступные узлы в кластере
