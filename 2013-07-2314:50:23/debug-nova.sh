#!/usr/bin/bash

sed -i ‘s/debug=False/debug=True/g’ /etc/nova/nova.conf
service openstack-nova-api restart
service openstack-nova-cert restart
service openstack-nova-compute restart
service openstack-nova-network restart
service openstack-nova-scheduler restart
#service openstack-nova-volume restart
#service openstack-nova-conductor restart

