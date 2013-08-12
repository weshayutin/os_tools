#!/bin/bash

cat > /usr/local/removeKernelNetworkingRules.sh << EOL
mv /etc/udev/rules.d/70-persistent-net.rules /root
#service network restart
DEVICE="eth0"
BOOTPROTO="dhcp"
NM_CONTROLLED="no"
ONBOOT="yes"
TYPE="Ethernet"

cat /dev/null > /etc/udev/rules.d/70-persistent-net.rules
chattr +i /etc/udev/rules.d/70-persistent-net.rules
=======
EOL
chmod +x /usr/local/removeKernelNetworkingRules.sh 

#DEVICE="eth0"
#BOOTPROTO="dhcp"
#NM_CONTROLLED="no"
#ONBOOT="yes"
#TYPE="Ethernet"
