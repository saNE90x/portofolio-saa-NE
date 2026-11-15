# RouterOS 7.6 - Core-3 (AS 6500 - Distribution Core & BGP RR-Client)
/system identity
set name=Core-3

/interface bridge
add name=lo

/ip address
add address=10.12.2.2/30 interface=ether1 network=10.12.2.0
add address=14.2.2.1/30 interface=ether2 network=14.2.2.0
add address=16.16.1.1/30 interface=ether3 network=16.16.1.0
add address=10.255.255.5/32 interface=lo network=10.255.255.5

/routing ospf instance
add disabled=no name=instance-v2 router-id=10.255.255.5

/routing ospf area
add disabled=no instance=instance-v2 name=backbone

/routing ospf interface-template
add area=backbone disabled=no interfaces=ether1 networks=10.12.2.0/30
add area=backbone disabled=no interfaces=ether2 networks=14.2.2.0/30
add area=backbone disabled=no interfaces=ether3 networks=16.16.1.0/30
add area=backbone disabled=no interfaces=lo networks=10.255.255.5/32 passive

/routing bgp template
add as=6500 name=core-3 router-id=10.255.255.5

/routing bgp connection
add connect=yes local.address=10.255.255.5 local.role=ibgp name=connect-RR-1 \
    remote.address=10.255.255.1 remote.as=6500 templates=core-3
add connect=yes local.address=10.255.255.5 local.role=ibgp name=connect-RR-2 \
    remote.address=10.255.255.2 remote.as=6500 templates=core-3
