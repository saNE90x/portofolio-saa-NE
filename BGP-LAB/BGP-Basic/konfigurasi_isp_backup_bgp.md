# ISP-Backup Router Configuration (`AS 200`)

## 1. IP Addressing & Loopback
Konfigurasi interface Loopback (`lo`) serta alamat IP *point-to-point* menuju `Upstream` (`ether1`) dan `R-Edge-2` (`ether2`):
* `ether1` (ke Upstream): `23.23.23.2/30`
* `ether2` (ke R-Edge-2): `10.2.2.1/30`
* `lo` (Loopback): `2.2.2.2/32`

```routeros
/interface bridge
add name=lo

/ip address
add address=23.23.23.2/30 interface=ether1
add address=10.2.2.1/30 interface=ether2
add address=2.2.2.2/32 interface=lo
```

---

## 2. Firewall Address-List (Network Advertisement)
Mengelompokkan daftar *prefix* milik `ISP-Backup` yang akan di-*advertise* ke BGP:

```routeros
/ip firewall address-list
add list=lan-backup address=23.23.23.0/30
add list=lan-backup address=10.2.2.0/30
add list=lan-backup address=2.2.2.2/32
```

---

## 3. BGP Configuration

### A. Membuat BGP Template
Menentukan parameter identitas BGP lokal dengan **AS Number (`200`)** dan **Router ID (`2.2.2.2`)**:

```routeros
/routing bgp template
add name=backup as=200 router-id=2.2.2.2
```

### B. Membuat BGP Connection (eBGP Peering)
Membangun sesi **eBGP** menuju `Upstream` (`AS 300`) serta menuju router pelanggan `R-Edge-2` (`AS 6500`) dengan menyebarkan rute default (`0.0.0.0/0`):

```routeros
# eBGP Peering menuju Upstream (AS 300) via ether1
/routing bgp connection
add name=ISP-Backup-To-eBGP-Upstream template=backup \
    remote.as=300 remote.address=23.23.23.1 local.role=ebgp \
    output.network=lan-backup connect=yes

# eBGP Peering menuju R-Edge-2 (AS 6500) via ether2
add name=ISP-Backup-To-eBGP-R-Edge-2 template=backup \
    remote.as=6500 remote.address=10.2.2.2 local.role=ebgp \
    output.network=lan-backup connect=yes output.default-originate=always
```

> **Catatan:** Konfigurasi *peering* eBGP dilakukan di kedua sisi (`ISP-Backup` dan router lawan `Upstream` / `R-Edge-2`) agar sesi BGP dapat terbentuk.

---

### 4. Firewall NAT (Akses Internet)
Menambahkan aturan *Source NAT (Masquerade)* pada interface yang mengarah ke `Upstream` (`ether1`) agar trafik dari jaringan pelanggan di bawahnya mendapatkan akses internet:

```routeros
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade
```

---

### 5. Verifikasi Peering
Untuk memastikan sesi eBGP dari `ISP-Backup` menuju `Upstream` dan `R-Edge-2` sudah aktif, jalankan perintah berikut:

```routeros
/routing/bgp/session/print
```

**Indikator Berhasil:** Kedua koneksi (`ISP-Backup-To-eBGP-Upstream` dan `ISP-Backup-To-eBGP-R-Edge-2`) muncul dengan status **`E` (*Established*)**.