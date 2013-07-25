#!/usr/bin/bash
if [ ! -d "/root/cinder-volumes" ]; then 
  mkdir -p /root/cinder-volumes
fi
pushd /root/cinder-volumes
dd if=/dev/zero of=cinder-volumes bs=1 count=0 seek=2G
sudo losetup /dev/loop2 cinder-volumes
sudo pvcreate /dev/loop2
sudo vgcreate cinder-volumes /dev/loop2
sudo service cinder-volume restart
sudo service cinder-api restart

#cinder create --display_name test 1
cinder list
