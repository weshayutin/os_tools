#!/usr/bin/bash

sed -i ‘s/debug=False/debug=True/g’ /etc/cinder/cinder.conf
service openstack-cinder-api restart
service openstack-cinder-volume restart
service openstack-cinder-scheduler restart

