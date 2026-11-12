# ==================================================
# Gateway Failover Configuration
# Platform : MikroTik CHR
# RouterOS : 7.6
# Method   : Netwatch Monitoring
# ==================================================


# --------------------------------------------------
# 1. INTERFACE CONFIGURATION
# --------------------------------------------------

/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik

/port
set 0 name=serial0
set 1 name=serial1


# --------------------------------------------------
# 2. DHCP CLIENT CONFIGURATION
# --------------------------------------------------

/ip dhcp-client
add interface=ether1 add-default-route=no comment="Primary WAN DHCP"
add interface=ether2 add-default-route=no comment="Backup WAN DHCP"


# --------------------------------------------------
# 3. ROUTING CONFIGURATION
# --------------------------------------------------

/ip route

# Primary Default Route
add dst-address=0.0.0.0/0 
    gateway=192.168.10.1 
    distance=1 
    scope=10 
    target-scope=30 
    comment="DEFAULT-PRIMARY"

# Backup Default Route
add dst-address=0.0.0.0/0 
    gateway=192.168.20.1 
    distance=2 
    scope=10 
    target-scope=30 
    comment="DEFAULT-BACKUP"

# Primary Gateway Monitoring Route
add dst-address=1.1.1.1/32 
    gateway=192.168.10.1 
    comment="MONITOR-PRIMARY"

# Backup Gateway Monitoring Route
add dst-address=1.1.1.2/32 
    gateway=192.168.20.1 
    comment="MONITOR-BACKUP"


# --------------------------------------------------
# 4. NETWATCH CONFIGURATION
# --------------------------------------------------

/tool netwatch

# Monitor Primary WAN
add host=1.1.1.1 
    type=simple 
    interval=5s 
    down-script="/ip route disable [find where comment=\"DEFAULT-PRIMARY\"]" 
    up-script="/ip route enable [find where comment=\"DEFAULT-PRIMARY\"]" 
    comment="PRIMARY-WAN-MONITOR"

# Monitor Backup WAN
add host=1.1.1.2 
    type=simple 
    interval=5s 
    down-script="/ip route disable [find where comment=\"DEFAULT-BACKUP\"]" 
    up-script="/ip route enable [find where comment=\"DEFAULT-BACKUP\"]" 
    comment="BACKUP-WAN-MONITOR"
