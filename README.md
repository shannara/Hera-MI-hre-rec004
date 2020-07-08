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
# example : workuser@69f25bd09d62:~$
# Now you can run fetch_datas.sh script to fetch dcm file from svc-node
# Run at prompt ./fetch_datas.sh
# example : workuser@de9e38a3cadd:~$ ./fetch_datas.sh
# You see similar output, files is fetching from svc-node
# example output :
#Warning: Permanently added '172.19.0.2' (ECDSA) to the list of known hosts.
#fuji-50333032.466243176.dcm    100%   53MB 165.7MB/s   00:00    
#ge-0001-0000-00000000.dcm      100%   14MB 162.1MB/s   00:00    
#hologic-MG02.dcm               100%   26MB 135.5MB/s   00:00    
#planmed-200064.424.dcm         100%   19MB 165.4MB/s   00:00   

# Open new terminal tab, and go to path Hera-MI-hre-rec004, if you put in datas folder
# you can see all .dcm files.
```