# R-Edge-1 Router Configuration (`AS 6500`)

## 1. IP Addressing & Loopback

Konfigurasi interface Loopback (`lo`) serta alamat IP *point-to-point* menuju `ISP-Backup` (`ether1`) dan `R-Edge-2` / Core (`ether2`):

* `ether1` (ke ISP-Backup): `10.2.2.2/30`
* `ether2` (ke R-Edge-2 / Core): `10.65.23.1/30`
* `lo` (Loopback): `10.255.255.2/32`

```routeros
/interface bridge
add name=lo

/ip address
add address=10.2.2.2/30 interface=ether1
add address=10.65.23.1/30 interface=ether2
add address=10.255.255.2/32 interface=lo
```

## 2. OSPF Configuration (IGP Underlay Internal)

Menggunakan dua protokol routing: **OSPF** untuk menjangkau jaringan internal **AS 6500** (khususnya IP Loopback) dan **BGP** untuk pertukaran rute eksternal.

> **Catatan:** Interface `ether1` yang mengarah ke `ISP-Backup` tidak dimasukkan ke dalam OSPF agar IGP tetap terisolasi di jaringan internal.

```routeros
# Membuat OSPF Instance
/routing ospf instance
add name=instance-v2 router-id=10.255.255.2

# Membuat OSPF Area Backbone
/routing ospf area
add name=backbone area-id=0.0.0.0 instance=instance-v2

# Mendaftarkan Interface & Network Internal ke OSPF
/routing ospf interface-template
add area=backbone interface=ether2 network=10.65.23.0/30
add area=backbone interface=lo network=10.255.255.2/32 passive
```

## 3. Firewall Address-List (Network Advertisement)

Setelah OSPF internal aktif, buat `address-list` untuk mengelompokkan *prefix* yang akan di-*advertise* melalui BGP:

```routeros
/ip firewall address-list
add list=lan-R-edge-1 address=10.2.2.0/30
add list=lan-R-edge-1 address=10.65.23.0/30
add list=lan-R-edge-1 address=10.255.255.2/32
```

## 4. BGP Configuration (eBGP & iBGP)

### A. Membuat BGP Template

Menentukan identitas dasar BGP lokal dengan **AS Number (`6500`)** dan **Router ID (`10.255.255.2`)**:

```routeros
/routing bgp template
add name=R-edge-1 as=6500 router-id=10.255.255.2
```

### B. Membuat BGP Connection

* **Interface `ether1` (eBGP):** Membangun sesi **eBGP** ke arah `ISP-Backup` (`AS 200`).
* **Via Loopback (iBGP):** Membangun sesi **iBGP** ke arah `R-Edge-2` / Core (`AS 6500`) menggunakan IP Loopback (`local.address=10.255.255.2`) dengan mengaktifkan `nexthop-choice=force-self`.

```routeros
# eBGP Peering menuju ISP-Backup (AS 200) via ether1
/routing bgp connection
add name=R-edge-1-To-eBGP-ISP-Backup template=R-edge-1 \
    remote.as=200 remote.address=10.2.2.1 local.role=ebgp \
    local.address=10.2.2.2 output.network=lan-R-edge-1 connect=yes

# iBGP Peering menuju R-Edge-2 / Core (AS 6500) via Loopback
add name=R-edge-1-To-iBGP-R-Edge-2 template=R-edge-1 \
    remote.as=6500 remote.address=10.255.255.3 local.role=ibgp \
    local.address=10.255.255.2 nexthop-choice=force-self \
    output.network=lan-R-edge-1 connect=yes
```

> **Catatan:** Pembentukan sesi *peering* BGP dilakukan di kedua sisi (`R-Edge-1` dengan `ISP-Backup` untuk **eBGP**, serta `R-Edge-1` dengan `R-Edge-2` untuk **iBGP**).

## 5. Firewall NAT (Akses Internet)

Menambahkan aturan *Source NAT (Masquerade)* pada interface yang mengarah ke `ISP-Backup` (`ether1`):

```routeros
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade
```

## 6. Verifikasi Peering

Untuk memastikan sesi OSPF internal serta *peering* **eBGP** (`ISP-Backup`) dan **iBGP** (`R-Edge-2`) sudah berjalan dan terhubung, jalankan perintah berikut:

```routeros
/routing/ospf/neighbor/print
/routing/bgp/session/print
```

**Indikator Berhasil:** Kedua koneksi BGP muncul dengan status **`E` (*Established*)** pada tabel sesi BGP.