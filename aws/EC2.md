# Main 
- Instance - virtual server
- Volumes - HDD/SSD discs
- Snapshot - резервная копия Volume
- AMI(Amazon Machine Images) - Резервная копия Instance

## Servers

- Intances - On Demand (почасовая оплата)
- Spot (ставки)
- Reserved (1-3 year)
- Scheduled Reserved (daily, weekly, monthly)
- Dedicated Hosts - полностью сервер 

## Types of servers

- t - general Purpose
- m - general purpose
- c - compute optimized
- f - fpga optimized
- g,P - GPU optimized
- x,r - RAM Memory Optimized (много памяти)
- D,I - Storage Optimized
- 
## Main words

- Instance - виртуальный сервер
- AMI - Inctance reserved copy

- Volume - HDD/SSD Диск
- Snapshot - Volume reserved copy 


# EBS - Elastic Block Store 

EBS - Хард диски 

**Types of discs**
root-boot:
- Genral Purpose SSD (GP2)  -  up to 10.000 iops
- Proisioned IOPS SSD (IO1) - подходит для баз данных - up to 20.000 iops
- Magnetic - обычный хард диск

other: 
- Cold HDD 
- Throughput Optimized HDD - оптимизирвоаный Magnetic 

## Самонастройка серверов

**Userdata** - настроеный скрипт для запуска команд при запуске инстенса
