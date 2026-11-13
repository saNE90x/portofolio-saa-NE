# ISP-Primary Configuration (`AS 100`)

## 1. IP Addressing
Konfigurasi alamat IP pada interface fisik dan interface Loopback (`lo`) di MikroTik:
* `ether1`: `13.13.13.2/30`
* `ether2`: `10.1.1.1/30`
* `lo`: `1.1.1.1/32`

```routeros
/ip address
add address=13.13.13.2/30 interface=ether1
add address=10.1.1.1/30 interface=ether2
add address=1.1.1.1/32 interface=lo
```

---

## 2. Firewall Address-List (Network Advertisement)
Membuat `address-list` pada menu firewall untuk meng-*advertise* network ke BGP:

```routeros
/ip firewall address-list
add list=lan-isp-primary address=13.13.13.0/30
add list=lan-primary address=10.1.1.0/30
add list=lan-primary address=1.1.1.1/32
```

---

## 3. BGP Configuration

### A. Membuat BGP Template
Membuat *template* BGP pada `/routing/bgp/template` dengan AS Number `100` dan Router ID `1.1.1.1`:

```routeros
/routing bgp template
add name=Primary as=100 router-id=1.1.1.1
```

### B. Membuat BGP Connection (eBGP Peering)
Membuat koneksi BGP untuk melakukan *peering* pada masing-masing interface:

```routeros
# Untuk Interface ether1 (ke Upstream)
/routing bgp connection
add name=ISP-Primary-To-eBGP-Upstream template=Primary \
    remote.as=300 remote.address=13.13.13.1 local.role=ebgp \
    output.network=lan-primary connect=yes output.default-originate=always

# Untuk Interface ether2 (ke R-Edge-1)
/routing bgp connection
add name=ISP-Primary-To-eBGP-R-Edge-1 template=Primary \
    remote.as=6500 remote.address=10.1.1.2 local.role=ebgp \
    output.network=lan-primary connect=yes output.default-originate=always
```

> **Catatan:** Konfigurasi BGP ini dilakukan di kedua sisi (`Upstream`, `ISP-Primary`, dan `ISP-Backup`) agar sesi *peering* sesama BGP dapat terbentuk dan terkoneksi.

---

## 4. Verifikasi Peering & Konfigurasi NAT

### A. Verifikasi Peering BGP
Untuk melihat apakah sesi eBGP sudah terhubung dengan lawan *peering*, jalankan perintah berikut:

```routeros
/routing/bgp/session/print
```

Jika status sudah **`Established`** dan muncul tabel eBGP lawan, maka *peering* eBGP sudah berjalan dan terkoneksi.

### B. Konfigurasi Firewall NAT (Akses Internet)
Tambahkan aturan *masquerade* pada interface keluar (`ether1`) agar jaringan di bawahnya bisa terhubung ke internet:

```routeros
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade
```