#!/bin/bash

mkdir ~/images
#wget -c https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img -O ~/images/cirros.img

glance image-create --name=cirros-0.3.1-x86_64 --disk-format=qcow2 --container-format=bare < cirros-0.3.1-x86_64-disk.img
