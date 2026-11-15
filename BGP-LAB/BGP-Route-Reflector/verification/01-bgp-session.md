# 01. Verifikasi Sesi Dynamic BGP Peering & Full-Mesh RR

Pengujian ini memverifikasi bahwa kedua Route Reflector (`RR-Edge-1` & `RR-Edge-2`) berhasil menerima koneksi otomatis dari seluruh router *client* (`10.255.255.3` – `10.255.255.7`) melalui mekanisme **Dynamic BGP Peering** (`local.role=ibgp-rr`, `listen=yes`) serta menjaga sesi *full-mesh* antar-RR.

## 1. Status Sesi BGP pada Route Reflector Utama (`RR-Edge-1` / `10.255.255.1`)

Perintah: `/routing/bgp/session/print`

```routeros
[admin@RR-Edge-1] > /routing/bgp/session/print
Flags: E - established 
 0 E name="RR-Edge-1-To-Primary-1" 
     remote.address=25.255.255.1 .as=100 .id=10.10.10.2 .capabilities=mp,rr,gr,as4 
     local.role=ebgp .address=25.255.255.2 .as=6500 .id=10.255.255.1 .capabilities=mp,rr,gr,as4

 1 E name="RR-Edge-1-To-eBGP-RR-Edge-2-1" 
     remote.address=10.255.255.2 .as=6500 .id=10.255.255.2 .capabilities=mp,rr,gr,as4 
     local.role=ibgp .address=10.255.255.1 .as=6500 .id=10.255.255.1 .capabilities=mp,rr,gr,as4

 2 E name="Dynamic-Peering-To-RR-Client-1" 
     remote.address=10.255.255.3 .as=6500 .id=10.255.255.3 .capabilities=mp,rr,gr,as4 
     local.role=ibgp-rr .address=10.255.255.1 .as=6500 .id=10.255.255.1 .capabilities=mp,rr,gr,as4 
     multihop=yes hold-time=3m keepalive-time=1m

 3 E name="Dynamic-Peering-To-RR-Client-2" 
     remote.address=10.255.255.4 .as=6500 .id=10.255.255.4 .capabilities=mp,rr,gr,as4 
     local.role=ibgp-rr .address=10.255.255.1 .as=6500 .id=10.255.255.1 .capabilities=mp,rr,gr,as4 
     multihop=yes hold-time=3m keepalive-time=1m

 4 E name="Dynamic-Peering-To-RR-Client-3" 
     remote.address=10.255.255.5 .as=6500 .id=10.255.255.5 .capabilities=mp,rr,gr,as4 
     local.role=ibgp-rr .address=10.255.255.1 .as=6500 .id=10.255.255.1 .capabilities=mp,rr,gr,as4 
     multihop=yes hold-time=3m keepalive-time=1m

 5 E name="Dynamic-Peering-To-RR-Client-4" 
     remote.address=10.255.255.6 .as=6500 .id=10.255.255.6 .capabilities=mp,rr,gr,as4 
     local.role=ibgp-rr .address=10.255.255.1 .as=6500 .id=10.255.255.1 .capabilities=mp,rr,gr,as4 
     multihop=yes hold-time=3m keepalive-time=1m

 6 E name="Dynamic-Peering-To-RR-Client-5" 
     remote.address=10.255.255.7 .as=6500 .id=10.255.255.7 .capabilities=mp,rr,gr,as4 
     local.role=ibgp-rr .address=10.255.255.1 .as=6500 .id=10.255.255.1 .capabilities=mp,rr,gr,as4 
     multihop=yes hold-time=3m keepalive-time=1m