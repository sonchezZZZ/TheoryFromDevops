Использование чужих чартов
Итак, мы дошли до завершающего шага в данном разделе, так давайте я покажу Вам всю прелесть и мощь Open-Source Community, утилиты Helm и взаимодействия с Кубернетес. 

Повторяйте за мной: 

helm repo add grafana https://grafana.github.io/helm-charts  # Добавляем репозиторий Хельм-Чартов

helm install grafana  stable/grafana                # Устанавливаем релиз grafana
 
kubectl get pods -w                                 # Пьем чай, пока Под Графаны не будет Running

kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo                                      
                                                    # Узнаем пароль от учетки admin

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace default port-forward $POD_NAME 3000

                                                    # Делаем проброс портов и заходим в браузер на  localhost:3000
Вау, мы только что развернули Графану в Кубернетес? Стоит нам научиться переопределять дефолтные параметры на параметры Вашей инфраструктуры и можно делать запись в резюме.



К сожалению, вряд ли мощностей наших компьютеров хватит, чтобы поставить что-то более серьезное, или на то, чтобы добавить Прометеус, построить свои дашборды и поиграть с алертами, но вы можете попробовать.

Как мы убедились, Хельм помогает легко переиспользовать приложения. В своих проектах в Банках мы стараемся почти все держать в Хельм-чартах, с помощью Хельма становится легко донастроить ванильный (голый) Kubernetes, о котором я писал в 1.2 до Инфраструктурный платформы.
