## kubectl-debug

Как правило командная оболочка контейнеров в подах имеет весьма ограниченный набор утилит, часто не хватает таких утилит, как netstat/ip/ping/curl/wget и т.п.

![image](https://user-images.githubusercontent.com/79608549/209569435-35c6799a-7e8c-4566-8ba2-7d09b62a38c3.png)

</br>

Для работы с **kubectl-debug** нужно установить себе бинарную утилиту из источника.

Далее нужно запустить такую команду для проблемного пода, Kubernetes подложит дебаг-контейнер Sidecar'ом к основному, тем самым расширит его возможности.

```kubectl-debug grafana-5556dc759c-wkbj4 --agentless=true --port-forward=true --agent-image=ksxack/debug-agent:v0.1```


Итак, мы расширили функционал Пода и у него появился curl. 

![image](https://user-images.githubusercontent.com/79608549/209569458-33f54d3b-cc4a-4a9b-8e5f-0dd539749e52.png)



## Debug Map
 большинство проблем с работой приложений в Кубернетес, будет легко решаться :)

![image](https://user-images.githubusercontent.com/79608549/209569507-5528079f-1732-47f8-b4ce-ba8a7b65f0fa.png)
