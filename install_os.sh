#!/bin/bash

if [ $1 == "grizzly" ]; then
  echo "grizzly install"
  yum install -y http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm
elif [ $1 == "trunk" ]; then
  if [[ `cat /etc/redhat-release` == *Fedora* ]]; then
    wget -O /etc/yum.repos.d/openstack-trunk.repo http://repos.fedorapeople.org/repos/openstack/openstack-trunk/fedora-openstack-trunk.repo
  else   
    wget -O /etc/yum.repos.d/openstack-trunk.repo  http://repos.fedorapeople.org/repos/openstack/openstack-trunk/el6-openstack-trunk.repo
  fi
else
  echo "options are:  grizzly, trunk"
fi

yum install -y openstack-packstack
packstack --gen-answer-file=ANSWER_FILE
sed -i 's/PW=.*/PW=dog8code/g' ANSWER_FILE
sed -i 's/TOKEN=.*/TOKEN=dog8code/g' ANSWER_FILE

#disable quantum/neutron 
sed -i 's/CONFIG_QUANTUM_INSTALL=y/CONFIG_QUANTUM_INSTALL=n/g' ANSWER_FILE

#packstack --answer-file=ANSWER_FILE
