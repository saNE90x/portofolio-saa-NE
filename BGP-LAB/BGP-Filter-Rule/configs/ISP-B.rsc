/system identity
set name=ISP-B

/ip address
add address=15.15.15.2/30 interface=ether1 network=15.15.15.0
add address=15.1.1.1/30 interface=ether2 network=15.1.1.0
/ip dhcp-client
add interface=ether1
/ip firewall address-list
add address=15.15.15.0/30 list=isp-b
add address=15.1.1.0/30 list=isp-b

/routing bgp template
add as=200 name=isp-b router-id=3.3.3.3

/routing bgp connection
add connect=yes local.role=ebgp name=isp-b-to-eBGP-upstream output.network=isp-b remote.address=15.15.15.1 .as=501 \
templates=isp-b
add local.role=ebgp name=ISP-B output.default-originate=always .network=isp-b remote.address=15.1.1.2 .as=1200 templates=\
isp-b
