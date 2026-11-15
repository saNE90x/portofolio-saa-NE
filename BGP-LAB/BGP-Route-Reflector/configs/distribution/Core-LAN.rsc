# RouterOS 7.6 - Core-LAN (AS 6500 - Edge LAN Distribution & BGP RR-Client)
/system identity
set name=Core-LAN

/interface bridge
add name=lo
add name=bridge-lan

/ip address
add address=16.16.1.2/30 interface=ether1 network=16.16.1.0
add address=15.15.15.2/30 interface=ether2 network=15.15.15.0
add address=192.168.15.1/24 interface=bridge-lan network=192.168.15.0
add address=10.255.255.6/32 interface=lo network=10.255.255.6

/routing ospf instance
add disabled=no name=instance-v2 router-id=10.255.255.6

/routing ospf area
add disabled=no instance=instance-v2 name=backbone

/routing ospf interface-template
add area=backbone disabled=no interfaces=ether1 networks=16.16.1.0/30
add area=backbone disabled=no interfaces=ether2 networks=15.15.15.0/30
add area=backbone disabled=no interfaces=bridge-lan networks=192.168.15.0/24 passive
add area=backbone disabled=no interfaces=lo networks=10.255.255.6/32 passive

/routing bgp template
add as=6500 name=core-lan router-id=10.255.255.6

/routing bgp connection
add connect=yes local.address=10.255.255.6 local.role=ibgp name=Core-LAN-To-RR-1 \
    remote.address=10.255.255.1 remote.as=6500 templates=core-lan
add connect=yes local.address=10.255.255.6 local.role=ibgp name=Core-LAN-To-RR-2 \
    remote.address=10.255.255.2 remote.as=6500 templates=core-lan
