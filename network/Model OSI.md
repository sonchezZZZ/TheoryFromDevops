
![image](https://user-images.githubusercontent.com/79608549/205645385-7e4f8b9a-49cb-48e7-8eb3-329b41b6cb2c.png)

Состоит она из 7 уровней и каждый уровень выполняет определенную ему роль и задачи. Разберем, что делает каждый уровень снизу вверх:

1)**Физический уровень (Physical Layer)**: определяет метод передачи данных, какая среда используется (передача электрических сигналов, световых импульсов или радиоэфир), уровень напряжения, метод кодирования двоичных сигналов.

2) **Канальный уровень (Data Link Layer)**: он берет на себя задачу адресации в пределах локальной сети, обнаруживает ошибки, проверяет целостность данных. Если слышали про MAC-адреса и протокол «Ethernet», то они располагаются на этом уровне.

3) **Сетевой уровень (Network Layer)**: этот уровень берет на себя объединения участков сети и выбор оптимального пути (т.е. маршрутизация). Каждое сетевое устройство должно иметь уникальный сетевой адрес в сети. Думаю, многие слышали про протоколы IPv4 и IPv6. Эти протоколы работают на данном уровне.

4) **Транспортный уровень (Transport Layer)**: Этот уровень берет на себя функцию транспорта. К примеру, когда вы скачиваете файл с Интернета, файл в виде сегментов отправляется на Ваш компьютер. Также здесь вводятся понятия портов, которые нужны для указания назначения к конкретной службе. На этом уровне работают протоколы TCP (с установлением соединения) и UDP (без установления соединения).

5) **Сеансовый уровень (Session Layer)**: Роль этого уровня в установлении, управлении и разрыве соединения между двумя хостами. К примеру, когда открываете страницу на веб-сервере, то Вы не единственный посетитель на нем. И вот для того, чтобы поддерживать сеансы со всеми пользователями, нужен сеансовый уровень.

6) **Уровень представления (Presentation Layer)**: Он структурирует информацию в читабельный вид для прикладного уровня. Например, многие компьютеры используют таблицу кодировки ASCII для вывода текстовой информации или формат jpeg для вывода графического изображения.

7) **Прикладной уровень (Application Layer)**: Наверное, это самый понятный для всех уровень. Как раз на этом уроне работают привычные для нас приложения — e-mail, браузеры по протоколу HTTP, FTP и остальное.

Самое главное помнить, что нельзя перескакивать с уровня на уровень (Например, с прикладного на канальный, или с физического на транспортный). Весь путь должен проходить строго с верхнего на нижний и с нижнего на верхний. Такие процессы получили название **инкапсуляция** (с верхнего на нижний) и **деинкапсуляция** (с нижнего на верхний). 

## Также стоит упомянуть, что на каждом уровне передаваемая информация называется по-разному.

- На **прикладном, представления и сеансовым уровнях**, передаваемая информация обозначается как PDU (Protocol Data Units). Сообщение/данные
- **транспортного уровня** называют сегментами (применимо только для протокола TCP) и датаграмма (для протокола UDP). 
- На **сетевом уровне** называют IP пакеты или просто пакеты.
- **на канальном уровне** — кадры. С одной стороны это все терминология и она не играет важной роли в том, как вы будете называть передаваемые данные, но для экзамена эти понятия лучше знать.
- **на физическом уровне** - биты


### Итак, приведу свой любимый пример, который помог мне, в мое время, разобраться с процессом инкапсуляции и деинкапусуляции:

1) Представим ситуацию, что вы сидите у себя дома за компьютером, а в соседней комнате у вас свой локальный веб-сервер. И вот вам понадобилось скачать файл с него. Вы набираете адрес страницы вашего сайта. Сейчас вы используете протокол HTTP, которые работает на прикладном уровне. Данные упаковываются и спускаются на уровень ниже.

2) Полученные данные прибегают на уровень представления. Здесь эти данные структурируются и приводятся в формат, который сможет быть прочитан на сервере. Запаковывается и спускается ниже.

3) На этом уровне создается сессия между компьютером и сервером.

4) Так как это веб сервер и требуется надежное установление соединения и контроль за принятыми данными, используется протокол TCP. Здесь мы указываем порт, на который будем стучаться и порт источника, чтобы сервер знал, куда отправлять ответ. Это нужно для того, чтобы сервер понял, что мы хотим попасть на веб-сервер (стандартно — это 80 порт), а не на почтовый сервер. Упаковываем и спускаем дальше.

5) Здесь мы должны указать, на какой адрес отправлять пакет. Соответственно, указываем адрес назначения (пусть адрес сервера будет 192.168.1.2) и адрес источника (адрес компьютера 192.168.1.1). Заворачиваем и спускаем дальше.

6) IP пакет спускается вниз и тут вступает в работу канальный уровень. Он добавляет физические адреса источника и назначения, о которых подробно будет расписано в последующей статье. Так как у нас компьютер и сервер в локальной среде, то адресом источника будет являться MAC-адрес компьютера, а адресом назначения MAC-адрес сервера (если бы компьютер и сервер находились в разных сетях, то адресация работала по-другому). Если на верхних уровнях каждый раз добавлялся заголовок, то здесь еще добавляется концевик, который указывает на конец кадра и готовность всех собранных данных к отправке.

7) И уже физический уровень конвертирует полученное в биты и при помощи электрических сигналов (если это витая пара), отправляет на сервер.

### Процесс деинкапсуляции аналогичен, но с обратной последовательностью:

1) На физическом уровне принимаются электрические сигналы и конвертируются в понятную битовую последовательность для канального уровня.

2) На канальном уровне проверяется MAC-адрес назначения (ему ли это адресовано). Если да, то проверяется кадр на целостность и отсутствие ошибок, если все прекрасно и данные целы, он передает их вышестоящему уровню.

3) На сетевом уровне проверяется IP адрес назначения. И если он верен, данные поднимаются выше. Не стоит сейчас вдаваться в подробности, почему у нас адресация на канальном и сетевом уровне. Это тема требует особого внимания, и я подробно объясню их различие позже. Главное сейчас понять, как данные упаковываются и распаковываются.

4) На транспортном уровне проверяется порт назначения (не адрес). И по номеру порта, выясняется какому приложению или сервису адресованы данные. У нас это веб-сервер и номер порта — 80.

5) На этом уровне происходит установление сеанса между компьютером и сервером.

6) Уровень представления видит, как все должно быть структурировано и приводит информацию в читабельный вид.

7) И на этом уровне приложения или сервисы понимают, что надо выполнить.

# Стек протоколов TCP/IP

Как было написано выше, модель OSI в наше время не используется. Пока разрабатывалась эта модель, все большую популярность получал стек протоколов TCP/IP. Он был значительно проще и завоевал быструю популярность.
Вот так этот стек выглядит:
![image](https://user-images.githubusercontent.com/79608549/205646209-f5f676c2-be06-46a9-be3a-e51a3691a929.png)


Как видно, он отличается от OSI и даже сменил название некоторых уровней. По сути, принцип у него тот же, что и у OSI. Но только три верхних уровня OSI: прикладной, представления и сеансовый объединены у TCP/IP в один, под названием прикладной. Сетевой уровень сменил название и называется — Интернет. Транспортный остался таким же и с тем же названием. А два нижних уровня OSI: канальный и физический объединены у TCP/IP в один с названием — уровень сетевого доступа. Стек TCP/IP в некоторых источниках обозначают еще как модель DoD (Department of Defence). Как говорит википедия, была разработана Министерством обороны США. Этот вопрос встретился мне на экзамене и до этого я про нее ничего не слышал. Соответственно вопрос: «Как называется сетевой уровень в модели DoD?», ввел меня в ступор. Поэтому знать это полезно.

Было еще несколько сетевых моделей, которые, какое то время держались. Это был стек протоколов IPX/SPX. Использовался с середины 80-х годов и продержался до конца 90-х, где его вытеснила TCP/IP. Был реализован компанией Novell и являлся модернизированной версией стека протоколов Xerox Network Services компании Xerox. Использовался в локальных сетях долгое время. Впервые IPX/SPX я увидел в игре «Казаки». При выборе сетевой игры, там предлагалось несколько стеков на выбор. И хоть выпуск этой игры был, где то в 2001 году, это говорило о том, что IPX/SPX еще встречался в локальных сетях.

Еще один стек, который стоит упомянуть — это AppleTalk. Как ясно из названия, был придуман компанией Apple. Создан был в том же году, в котором состоялся релиз модели OSI, то есть в 1984 году. Продержался он совсем недолго и Apple решила использовать вместо него TCP/IP.

Также хочу подчеркнуть одну важную вещь. Token Ring и FDDI — не сетевые модели! Token Ring — это протокол канального уровня, а FDDI это стандарт передачи данных, который как раз основывается на протоколе Token Ring. Это не самая важная информация, так как эти понятия сейчас не встретишь. Но главное помнить о том, что это не сетевые модели.
