# VPC 

**VPC** - Virtual cloud private  (виртуальная изолированя Сеть)

## Components 

- **public subnet** (все серверы имет PublicIP и прямой доступ в интернет)
- **VPC CIDR blocks** (блоки подсети )
- **private subnet** (нет публичных айпи, нет доступа к интернету) - все серверы НЕ имеют PublicIP и имеют доступ в интернет через NAT
- **database subnet** (private subnet) - все серверы НЕ имеют PublicIP и НЕ имеют доступ в интернет 
- **Route table** - роутинг трафика
- **Internate gateway** - добавляет доступ к интернету
- **Nat Gateway** - (шлюз для доступа к subnet из интернета  )
- **Nat instance** 
- **Security group**
- **Network Access Control List** (добавляется к инстенсу, конфигурация разрешения и блокировки доступа к сабнету и in и out)
- **Bastion Host** (Хост для доступа ко всем сабнетов )
- **VPC Flow Logs** (логи )
- **VPN Gateway** (настройка доступа через ВПН)
- **VPC Peering** (как соединять сети одна vpc к другой)

## VPC size 

> 10.0.0.0/16 - 65,536 IP addresses
> 10.0.0.0/24 - 254 IP addresses ()
> 10.0.0.0/28 - 16 IP addresses
