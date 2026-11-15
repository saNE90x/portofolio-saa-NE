# RouterOS 7.6 - RR-Edge-2 (AS 6500 - Backup Edge & Route Reflector 2)
/system identity
set name=RR-Edge-2

/interface bridge
add name=lo

/ip address
add address=14.14.14.1/30 interface=ether1 network=14.14.14.0
add address=172.16.10.2/30 interface=ether2 network=172.16.10.0
add address=172.16.30.1/30 interface=ether3 network=172.16.30.0
add address=12.12.12.1/30 interface=ether4 network=12.12.12.0
add address=10.255.255.2/32 interface=lo network=10.255.255.2

/ip dns
set servers=8.8.8.8

/ip firewall address-list
add address=14.14.14.0/30 list=RR-Edge2
add address=172.16.10.0/30 list=RR-Edge2
add address=172.16.30.0/30 list=RR-Edge2
add address=10.255.255.2 list=RR-Edge2

/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1

/routing ospf instance
add disabled=no name=instance-v2 router-id=10.255.255.2

/routing ospf area
add disabled=no instance=instance-v2 name=backbone

/routing ospf interface-template
add area=backbone disabled=no interfaces=ether2 networks=172.16.10.0/30
add area=backbone disabled=no interfaces=ether3 networks=172.16.30.0/30
add area=backbone disabled=no interfaces=ether4 networks=12.12.12.0/30
add area=backbone disabled=no interfaces=lo networks=10.255.255.2/32 passive

/routing bgp template
add as=6500 name=edge-2 router-id=10.255.255.2

/routing bgp connection
add connect=yes local.role=ebgp name=RR-Edge-2-To-Backup \
    output.network=RR-Edge2 remote.address=14.14.14.2 remote.as=200 templates=edge-2
add connect=yes local.address=10.255.255.2 local.role=ibgp name=RR-Edge-2-To-RR-Edge-1 \
    nexthop-choice=force-self output.network=RR-Edge2 remote.address=10.255.255.1 remote.as=6500 templates=edge-2
add connect=no listen=yes local.address=10.255.255.2 local.role=ibgp-rr name=Dynamic-Peering-To-RR-Client \
    nexthop-choice=force-self output.default-originate=always output.network=RR-Edge2 \
    remote.address=10.255.255.0/24 remote.as=6500 templates=edge-2
