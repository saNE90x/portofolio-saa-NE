/system identity
set name=ISP-A

/ip address
add address=10.10.10.2/30 interface=ether1 network=10.10.10.0
add address=11.1.1.1/30 interface=ether2 network=11.1.1.0

/ip dhcp-client
add interface=ether1

/ip firewall address-list
add address=10.10.10.0/30 list=isp-a-list
add address=11.1.1.0/30 list=isp-a-list

/routing bgp template
add as=100 name=isp-a router-id=2.2.2.2

/routing bgp connection
add connect=yes local.role=ebgp name=isp-a-eBGP-To-Upstream output.network=isp-a-list remote.address=10.10.10.1 .as=501 \
templates=isp-a
add local.role=ebgp name=isp-a-eBGP-To-RR-1 output.default-originate=always .network=isp-a-list remote.address=11.1.1.2 \
.as=1200 templates=isp-a
