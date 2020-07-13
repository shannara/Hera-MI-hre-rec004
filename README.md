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

step2
-----

```shell
git checkout step2
# if you are not in docker group prefix docker-compose command with sudo
docker-compose build
# You run svc-node container on background, it's fetch datas and serve them via scp
docker-compose up -d svc-node
# Now you can run worker container, and fetch datas from svc-node with fetch_datas.sh script
docker-compose run worker
# You enter on worker container and prompt inside at workuser
# example : workuser@4791e1d475a2:~$
# Now you can run fetch_datas.sh script to fetch dcm file from svc-node
# Run at prompt ./fetch_datas.sh
# example : workuser@4791e1d475a2:~$ ./fetch_datas.sh
# You see similar output, files is fetching from svc-node
# example output :
#Warning: Permanently added '172.19.0.2' (ECDSA) to the list of known hosts.
#fuji-50333032.466243176.dcm    100%   53MB 165.7MB/s   00:00    
#ge-0001-0000-00000000.dcm      100%   14MB 162.1MB/s   00:00    
#hologic-MG02.dcm               100%   26MB 135.5MB/s   00:00    
#planmed-200064.424.dcm         100%   19MB 165.4MB/s   00:00   

# Open new terminal tab, and go to path Hera-MI-hre-rec004, if you put in datas folder
# you can see all .dcm files.
# Now you need run extract_datas.sh script to dump dcm files
# example : workuser@4791e1d475a2:~$ ./extract_datas.sh
# You see similar output, files is dump in /home/workuser/datas/dumps
# example output :
#workuser@4791e1d475a2:~$ ./extract_datas.sh
#Dump fuji-50333032.466243176.dcm in fuji-50333032.466243176.dump...  done
#Dump ge-0001-0000-00000000.dcm in ge-0001-0000-00000000.dump...  done
#Dump hologic-MG02.dcm in hologic-MG02.dump...  done
#Dump planmed-200064.424.dcm in planmed-200064.424.dump...  done
# You can check if files is dumped correctly with running at prompt ls datas/dumps
#workuser@4791e1d475a2:~$ ls datas/dumps/
#fuji-50333032.466243176.dump  ge-0001-0000-00000000.dump    hologic-MG02.dump             planmed-200064.424.dump
```

step3
-----

```shell
git checkout step3
# if you are not in docker group prefix docker-compose command with sudo
docker-compose build
# You have normally already running svc-node (step1).
# Instead of store dcm dump datas in files, we will stored them in MongoDB,
# to do thim, run db container   
docker-compose up -d db
# Now you need rebuild worker container to use new scripts and method
docker-compose build worker
# You enter on worker container and prompt inside at workuser
# example : workuser@d5b183b49027:~$
# Now you can again run fetch_datas.sh script to fetch dcm file from svc-node
# Run at prompt ./fetch_datas.sh
# example : workuser@d5b183b49027:~$ ./fetch_datas.sh
# You see similar output, files is fetching from svc-node
# example output :
#Warning: Permanently added '172.19.0.2' (ECDSA) to the list of known hosts.
#fuji-50333032.466243176.dcm    100%   53MB 165.7MB/s   00:00    
#ge-0001-0000-00000000.dcm      100%   14MB 162.1MB/s   00:00    
#hologic-MG02.dcm               100%   26MB 135.5MB/s   00:00    
#planmed-200064.424.dcm         100%   19MB 165.4MB/s   00:00   

# Now you need run extract_datas.sh script to dump dcm files and store them
# in collection inside MongoDB
# example : workuser@d5b183b49027:~$ ./extract_datas.sh
# You see similar output, files is dump in /home/workuser/datas/dumps
# example output :
#workuser@d5b183b49027:~$ ./extract_datas.sh
#Import fuji-50333032.466243176.dcm
#Success
#Import ge-0001-0000-00000000.dcm
#Success
#Import hologic-MG02.dcm
#Success
#Import planmed-200064.424.dcm
#Success
# You can check if files is correctly insert in MongoDB, in another terminal tab,
# run this
docker exec -it db bash
# You switch prompt inside container db
# example: root@6c9806ee624d:/#
# Enter on MongoDB shell with `mongo -u root -p` (password is rockmyroot)
# example: root@6c9806ee624d:/# mongo -u root -p
# Now you are inside MongoDB Shell
# >
# Switch to HRE database with `use HRE`
> use HRE
# Display document inside collection dcmdump with `db.dcmdump.find()`
> db.dcmdump.find()
# You see similar output
# { "_id" : "fuji-50333032.466243176.dcm", "StudyInstanceUID" : "1.2.392.200036.9125.2.10452022710478.64807052031.10442",
# "SeriesInstanceUID" : "1.2.392.200036.9125.3.10452022710478.64807052048.10448", "SOPInstanceUID" : "1.2.392.200036.9125.4.0.2718896371.50333032.466243176" }
# { "_id" : "ge-0001-0000-00000000.dcm", "StudyInstanceUID" : "1.2.840.113619.2.227.2079247136136.28401170811121541.20000",
# "SeriesInstanceUID" : "1.2.840.113619.2.227.2079247136136.28401170811121638.10005", "SOPInstanceUID" : "1.2.840.113619.2.227.2079247136136.2066170811121639.131" }
# { "_id" : "hologic-MG02.dcm", "StudyInstanceUID" : "1.2.840.113681.180879638.1548403878.4704.14592",
# "SeriesInstanceUID" : "1.2.840.113681.180879638.1548403878.4704.14696", "SOPInstanceUID" : "1.2.840.113681.180879638.1548403878.4704.14697" }
# { "_id" : "planmed-200064.424.dcm", "StudyInstanceUID" : "2.16.840.1.113669.632.20.20140513.192554394.19.415",
# "SeriesInstanceUID" : "2.16.840.1.113669.632.20.20140513.202407240.8494.427", "SOPInstanceUID" : "2.16.840.1.113669.632.20.20140513.202406491.200064.424" }
```

step4
-----

```shell
git checkout step4
# if you are not in docker group prefix docker-compose command with sudo
# To ensure security traffic between container, you need setup VPN server,
# in case OpenVPN.
# In first step, you need create external network "vpn", this network will be
# used for vpn traffic between container.
docker network create vpn
# You need show subnet assigned to vpn network
docker network inspect vpn |grep Subnet
# example output
# "Subnet": "172.25.0.0/16",
# You see that subnet is 172.25.0.0/16, openvpn was first container running, gateway is 172.25.0.1,
# then 172.25.0.2 will be IP address assigned for OpenVPN container.
# Copy dist file as ovpn_env.sh and set OpenVPN IP address
cp openvpn-data/ovpn_env.sh.dist openvpn-data/ovpn_env.sh
sed -i 's/DOCKER_VPN_IPADDR/172.25.0.2/g' openvpn-data/ovpn_env.sh
# Run this command to generate openvpn config
docker-compose run --rm openvpn ovpn_genconfig -u udp://172.25.0.2
# Now you need create CA key, use this command to do this
docker-compose run --rm openvpn ovpn_initpki
# When prompt ask CA Key Passphrase, enter passphrase and type Enter,
# (for security nothing is display), and again to confirm.
# You need this passphrase later, don't forget them
# example output
# Enter New CA Key Passphrase:
# Re-Enter New CA Key Passphrase:
# After key is generate, you need set Common Name for CA, by default if you type
# enter is 'Easy-RSA CA', you can type openvpn (name of container) follow by enter
# Common Name (eg: your user, host, or server name) [Easy-RSA CA]:
Common Name (eg: your user, host, or server name) [Easy-RSA CA]: openvpn
# Script generate CA Key and CA certificate, at last, he ask to enter passphrase
# of the CA Key to create and sign CA certificate (enter passphrase follow by Enter)
Enter pass phrase for /etc/openvpn/pki/private/ca.key:
# Check that the request matches the signature
# Signature ok
# The Subject's Distinguished Name is as follows
# ..
Enter pass phrase for /etc/openvpn/pki/private/ca.key:
# An updated CRL has been created.
# Now you have OpenVPN config ready, it's time to setup openvpn config for each clients
# svc-node, worker, db, during generate, script ask passphrase for CA Key, again nothing
# is display when you enter pass phrase (follow by Enter)
for client in "svc-node" "worker" "db"
do
  docker-compose run --rm openvpn easyrsa build-client-full $client nopass
done
# Now you need to save each openvpn client config file for build container with them
for client in "svc-node" "worker" "db"
do
  docker-compose run --rm openvpn ovpn_getclient $client > $client/$client.ovpn
done
# You can run openvpn container in background
docker-compose up -d openvpn
# Now you need rebuild all containers to use openvpn config
docker-compose build db svc-node worker
# Run svc-node and db containers
docker-compose up -d db svc-node
# Run worker container
docker-compose up -d worker
# You can run fetch_datas and extract_datas script inside worker
docker exec -it worker bash
# you enter in worker container and prompt
# example: root@08f73fb333b1:~#
# To fetch datas, same as step3 use ./fetch_datas.sh
# example :
#root@08f73fb333b1:~# ./fetch_datas.sh
# You see this output, note 192.168.255.10 is VPN IP address of svc-node
#Warning: Permanently added '192.168.255.10' (ECDSA) to the list of known hosts.
#fuji-50333032.466243176.dcm       100%   53MB  25.3MB/s   00:02
#ge-0001-0000-00000000.dcm         100%   14MB  26.6MB/s   00:00
#hologic-MG02.dcm                  100%   26MB  25.3MB/s   00:01
#planmed-200064.424.dcm            100%   19MB  25.0MB/s   00:00
# To extract datas dump and put them on mongo database, use ./extract_datas.sh
#root@08f73fb333b1:~# ./extract_datas.sh
#Import fuji-50333032.466243176.dcm
#Success
#Import ge-0001-0000-00000000.dcm
#Success
#Import hologic-MG02.dcm
#Success
#Import planmed-200064.424.dcm
#Success

