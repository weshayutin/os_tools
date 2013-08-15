nova secgroup-create test test
nova secgroup-add-rule test icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule test tcp 1 65535 0.0.0.0/0 
