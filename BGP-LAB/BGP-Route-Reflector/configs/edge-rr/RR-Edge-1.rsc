# RouterOS 7.6 - RR-Edge-1 (AS 6500 - Primary Edge & Route Reflector 1)
/system identity
set name=RR-Edge-1

/interface bridge
add name=lo

/ip address
add address=25.25.25.2/30 interface=ether1 network=25.25.25.0
add address=172.16.10.1/30 interface=ether2 network=172.16.10.0
add address=172.16.1.1/30 interface=ether3 network=172.16.1.0
add address=30.30.30.1/30 interface=ether4 network=30.30.30.0
add address=10.255.255.1/32 interface=lo network=10.255.255.1

/ip dns
set servers=8.8.8.8

/ip firewall address-list
add address=25.25.25.0/30 list=RR-Edge1
add address=172.16.10.0/30 list=RR-Edge1
add address=172.16.1.0/30 list=RR-Edge1
add address=10.255.255.1 list=RR-Edge1

/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1

/routing ospf instance
add disabled=no name=instance-v2 router-id=10.255.255.1

/routing ospf area
add disabled=no instance=instance-v2 name=backbone

/routing ospf interface-template
add area=backbone disabled=no interfaces=ether2 networks=172.16.10.0/30
add area=backbone disabled=no interfaces=ether3 networks=172.16.1.0/30
add area=backbone disabled=no interfaces=ether4 networks=30.30.30.0/30
add area=backbone disabled=no interfaces=lo networks=10.255.255.1/32 passive

/routing bgp template
add as=6500 name=edge-1 router-id=10.255.255.1

/routing bgp connection
add connect=yes local.role=ebgp name=RR-Edge-1-To-Primary \
    output.network=RR-Edge1 remote.address=25.25.25.1 remote.as=100 templates=edge-1
add connect=yes local.address=10.255.255.1 local.role=ibgp name=RR-Edge-1-To-eBGP-RR-Edge-2 \
    nexthop-choice=force-self output.network=RR-Edge1 remote.address=10.255.255.2 remote.as=6500 templates=edge-1
add connect=no listen=yes local.address=10.255.255.1 local.role=ibgp-rr name=Dynamic-Peering-To-RR-Client \
    nexthop-choice=force-self output.default-originate=always output.network=RR-Edge1 \
    remote.address=10.255.255.0/24 remote.as=6500 templates=edge-1
