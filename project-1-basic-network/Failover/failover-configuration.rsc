# nov/12/2026 01:15:20 by RouterOS 7.6
# software id = 
#
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
set 1 name=serial1
/ip dhcp-client
add add-default-route=no interface=ether1
add add-default-route=no interface=ether2
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=192.168.10.1 scope=10 \
    target-scope=30
add disabled=no distance=2 dst-address=0.0.0.0/0 gateway=192.168.20.1 scope=\
    10 target-scope=30
add dst-address=1.1.1.1/32 gateway=192.168.10.1
add dst-address=1.1.1.2/32 gateway=192.168.20.1
/tool netwatch
add down-script="ip route/disable numbers=1" host=1.1.1.1 interval=5s type=\
    simple up-script="ip route/enable numbers=1"
add down-script="ip route/disable numbers=0" host=1.1.1.2 interval=5s type=\
    simple up-script="ip route/enable numbers=0"
