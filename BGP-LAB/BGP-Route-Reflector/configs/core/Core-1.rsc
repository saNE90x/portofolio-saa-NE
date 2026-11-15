# RouterOS 7.6 - Core-1 (AS 6500 - Core Router & BGP RR-Client)
/system identity
set name=Core-1

/interface bridge
add name=lo

/ip address
add address=172.16.1.2/30 interface=ether1 network=172.16.1.0
add address=12.12.12.2/30 interface=ether2 network=12.12.12.0
add address=10.12.1.1/30 interface=ether3 network=10.12.1.0
add address=10.12.2.1/30 interface=ether4 network=10.12.2.0
add address=10.255.255.3/32 interface=lo network=10.255.255.3

/routing ospf instance
add disabled=no name=instance-v2 router-id=10.255.255.3

/routing ospf area
add disabled=no instance=instance-v2 name=backbone

/routing ospf interface-template
add area=backbone disabled=no interfaces=ether1 networks=172.16.1.0/30
add area=backbone disabled=no interfaces=ether2 networks=12.12.12.0/30
add area=backbone disabled=no interfaces=ether3 networks=10.12.1.0/30
add area=backbone disabled=no interfaces=ether4 networks=10.12.2.0/30
add area=backbone disabled=no interfaces=lo networks=10.255.255.3/32 passive

/routing bgp template
add as=6500 name=core-1 router-id=10.255.255.3

/routing bgp connection
add connect=yes local.address=10.255.255.3 local.role=ibgp name=connect-RR-1 \
    remote.address=10.255.255.1 remote.as=6500 templates=core-1
add connect=yes local.address=10.255.255.3 local.role=ibgp name=connect-RR-2 \
    remote.address=10.255.255.2 remote.as=6500 templates=core-1
