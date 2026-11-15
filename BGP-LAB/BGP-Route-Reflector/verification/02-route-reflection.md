---

### 2. `verification/02-route-reflection.md`

```markdown
# 02. Verifikasi Route Reflection & Tabel Routing BGP (Control Plane)

Pengujian ini membuktikan bahwa rute eksternal dari Upstream (`AS 350`) dan kedua ISP (`AS 100` & `AS 200`) dipantulkan secara redundan oleh `RR-Edge-1` (`10.255.255.1`) dan `RR-Edge-2` (`10.255.255.2`) ke router ujung paling dalam (`Core-LAN` / `10.255.255.6`), dengan resolusi *next-hop* menggunakan OSPF ECMP.

## 1. Detail Tabel Routing BGP pada `Core-LAN` (`10.255.255.6`)

Perintah: `/ip/route/print detail where bgp`

```routeros
[admin@Core-LAN] > /ip/route/print detail where bgp
Flags: D - dynamic; X - disabled, I - inactive, A - active; 
c - connect, s - static, r - rip, b - bgp, o - ospf, d - dhcp, v - vpn, m - modem, y - copy; H - hw-offloaded; + - ecmp 
D b + dst-address=0.0.0.0/0 routing-table=main gateway=10.255.255.2 immediate-gw=16.16.1.1%ether1,15.15.15.1%ether2 
      distance=200 scope=40 target-scope=30 suppress-hw-offload=no 

DAb + dst-address=0.0.0.0/0 routing-table=main gateway=10.255.255.1 immediate-gw=16.16.1.1%ether1,15.15.15.1%ether2 
      distance=200 scope=40 target-scope=30 suppress-hw-offload=no 

D b + dst-address=1.1.1.1/32 routing-table=main gateway=10.255.255.2 immediate-gw=16.16.1.1%ether1,15.15.15.1%ether2 
      distance=200 scope=40 target-scope=30 suppress-hw-offload=no 

DAb + dst-address=1.1.1.1/32 routing-table=main gateway=10.255.255.1 immediate-gw=16.16.1.1%ether1,15.15.15.1%ether2 
      distance=200 scope=40 target-scope=30 suppress-hw-offload=no 

D b + dst-address=2.2.2.2/32 routing-table=main gateway=10.255.255.1 immediate-gw=16.16.1.1%ether1,15.15.15.1%ether2 
      distance=200 scope=40 target-scope=30 suppress-hw-offload=no 

DAb + dst-address=2.2.2.2/32 routing-table=main gateway=10.255.255.1 immediate-gw=16.16.1.1%ether1,15.15.15.1%ether2 
      distance=200 scope=40 target-scope=30 suppress-hw-offload=no 

DAb + dst-address=3.3.3.3/32 routing-table=main gateway=10.255.255.2 immediate-gw=16.16.1.1%ether1,15.15.15.1%ether2 
      distance=200 scope=40 target-scope=30 suppress-hw-offload=no 

D b + dst-address=3.3.3.3/32 routing-table=main gateway=10.255.255.2 immediate-gw=16.16.1.1%ether1,15.15.15.1%ether2 
      distance=200 scope=40 target-scope=30 suppress-hw-offload=no