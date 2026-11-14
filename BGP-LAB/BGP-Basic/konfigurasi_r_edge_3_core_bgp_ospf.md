# R-Edge-3 (Core) Router Configuration (`AS 6500`)

## 1. IP Addressing & Loopback

Konfigurasi interface Loopback (`lo`), jalur internal menuju kedua router Edge (`ether1` & `ether2`), serta jaringan LAN (`ether3`):

* `ether1` (ke R-Edge): `10.65.13.2/30`
* `ether2` (ke R-Edge-1): `10.65.23.2/30`
* `ether3` (LAN Internal / Publik): `103.10.10.1/24`
* `lo` (Loopback): `10.255.255.3/32`

```routeros
/interface bridge
add name=lo

/ip address
add address=10.65.13.2/30 interface=ether1
add address=10.65.23.2/30 interface=ether2
add address=103.10.10.1/24 interface=ether3
add address=10.255.255.3/32 interface=lo
```

## 2. OSPF Configuration (IGP Underlay Internal)

Menggunakan **OSPF** sebagai *IGP underlay* di dalam **AS 6500** agar `R-Edge-3` (Core) dapat menjangkau IP Loopback milik `R-Edge` (`10.255.255.1/32`) dan `R-Edge-1` (`10.255.255.2/32`) sebelum sesi iBGP dibangun:

```routeros
# Membuat OSPF Instance
/routing ospf instance
add name=instance-v2 router-id=10.255.255.3

# Membuat OSPF Area Backbone
/routing ospf area
add name=backbone area-id=0.0.0.0 instance=instance-v2

# Mendaftarkan Interface & Network Internal ke OSPF
/routing ospf interface-template
add area=backbone interface=ether1 network=10.65.13.0/30
add area=backbone interface=ether2 network=10.65.23.0/30
add area=backbone interface=ether3 network=103.10.10.0/24 passive
add area=backbone interface=lo network=10.255.255.3/32 passive
```

## 3. Firewall Address-List (Network Advertisement)

Mengelompokkan *prefix* milik `R-Edge-3` (termasuk subnet LAN `103.10.10.0/24`) yang akan di-*advertise* ke kedua router Edge melalui iBGP:

```routeros
/ip firewall address-list
add list=lan-R-edge-3 address=10.65.13.0/30
add list=lan-R-edge-3 address=10.65.23.0/30
add list=lan-R-edge-3 address=103.10.10.0/24
add list=lan-R-edge-3 address=10.255.255.3/32
```

## 4. BGP Configuration (iBGP Peering)

### A. Membuat BGP Template

Menentukan parameter identitas BGP lokal dengan **AS Number (`6500`)** dan **Router ID (`10.255.255.3`)**:

```routeros
/routing bgp template
add name=R-edge-3 as=6500 router-id=10.255.255.3
```

### B. Membuat BGP Connection

Membangun dua sesi **iBGP** melalui **IP Loopback** (`local.address=10.255.255.3`) menuju `R-Edge` (`10.255.255.1`) dan `R-Edge-1` (`10.255.255.2`) untuk menerima rute eksternal serta mengiklankan network LAN `103.10.10.0/24`:

```routeros
# iBGP Peering menuju R-Edge (AS 6500) via Loopback
/routing bgp connection
add name=R-edge-3-To-iBGP-R-Edge template=R-edge-3 \
    remote.as=6500 remote.address=10.255.255.1 local.role=ibgp \
    local.address=10.255.255.3 output.network=lan-R-edge-3 connect=yes

# iBGP Peering menuju R-Edge-1 (AS 6500) via Loopback
add name=R-edge-3-To-iBGP-R-Edge-1 template=R-edge-3 \
    remote.as=6500 remote.address=10.255.255.2 local.role=ibgp \
    local.address=10.255.255.3 output.network=lan-R-edge-3 connect=yes
```

> **Catatan:** Pembentukan sesi *peering* **iBGP** bersifat dua arah, sehingga konfigurasi serupa juga diterapkan pada sisi `R-Edge` dan `R-Edge-1` yang mengarah ke Loopback `10.255.255.3`.

## 5. Verifikasi OSPF & iBGP Peering

Untuk memastikan neighbor OSPF sudah `Full` dan kedua sesi **iBGP** menuju `R-Edge` serta `R-Edge-1` sudah aktif, jalankan perintah berikut:

```routeros
/routing/ospf/neighbor/print
/routing/bgp/session/print
/ip/route/print where bgp
```

**Indikator Berhasil:** Kedua koneksi iBGP berstatus **`E` (*Established*)**, dan tabel routing menampilkan rute default (`0.0.0.0/0`) serta rute eksternal dengan flag **`DAb` (*Dynamic Active BGP*)**.