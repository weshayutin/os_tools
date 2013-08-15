neutron net-create public --router:external=True
neutron subnet-create public 172.16.1.0/24
neutron net-list -- --router:external=True

