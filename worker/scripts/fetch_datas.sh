#!/bin/bash

# Fetch datas from svc-node
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r filer@172.19.0.2:~/test_material/task_01-software_engineer/phantoms-2d/* ~/datas/.
