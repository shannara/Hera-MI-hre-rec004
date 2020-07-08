Hera-MI Test Entrance
==============================

## Requirements

* Docker
* docker-compose
* You need member of docker group or allow to use sudo

## Installation

```shell
git clone https://github.com/shannara/Hera-MI-hre-rec004.git
cd Hera-MI-hre-rec004
```

Each steps as on separated branch

step1
-----

```shell
git checkout step1
# if you are not in docker group prefix docker-compose command with sudo
docker-compose build
# You run svc-node container on background, it's fetch datas and serve them via scp
docker-compose up -d svc-node
# Now you can run worker container, and fetch datas from svc-node with fetch_datas.sh script
docker-compose run worker
# You enter on worker container and prompt inside at workuser
# example
# workuser@69f25bd09d62:~$
# Now you can run fetch_datas.sh script to fetch dcm file from c1
 workuser@69f25bd09d62:~$ ./fetch_datas.sh
```
