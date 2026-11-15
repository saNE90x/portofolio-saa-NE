# Redundant BGP Route Reflector & OSPF Underlay Architecture (MikroTik RouterOS v7)

Simulasi arsitektur jaringan Enterprise/ISP multi-homed (AS 6500) menggunakan **MikroTik RouterOS v7** di PNETLab. Proyek ini mengimplementasikan **Dual Route Reflector (RR) Redundancy**, **BGP Dynamic Peering**, serta **OSPF ECMP Underlay** untuk menghilangkan kebutuhan konfigurasi *full-mesh* iBGP yang kompleks tanpa mengorbankan *high availability*.

---

## 1. Arsitektur & Desain Jaringan

* **Autonomous System (AS) Internal:** `AS 6500`
* **Upstream & Transit Providers:**
  * `ISP-Primary` (`AS 100`) — terhubung ke `RR-Edge-1`
  * `ISP-Backup` (`AS 200`) — terhubung ke `RR-Edge-2`
  * `Upstream` (`AS 350`) — *tier-1 upstream* yang terhubung ke kedua ISP
* **IGP Underlay (OSPFv2 Area Backbone):** Menjamin konektivitas antar-IP Loopback (`10.255.255.0/24`) dengan dukungan *Equal-Cost Multi-Path* (ECMP) melalui topologi *partial-mesh* bersilang.
* **Control Plane (BGP Route Reflector):**
  * `RR-Edge-1` (`10.255.255.1`) dan `RR-Edge-2` (`10.255.255.2`) berperan sebagai **Dual Route Reflector (`local.role=ibgp-rr`)** dengan fitur **Dynamic Peering** (`connect=no listen=yes`) untuk menerima koneksi otomatis dari seluruh *client* di subnet `10.255.255.0/24`.
  * Antar-RR (`RR-Edge-1` $\longleftrightarrow$ `RR-Edge-2`) terhubung secara **Full-Mesh iBGP (`local.role=ibgp`)** untuk sinkronisasi rute eksternal.
  * Seluruh router internal (`Core-1` s/d `Core-4` dan `Core-LAN`) bertindak sebagai **RR-Client (`local.role=ibgp`)** yang hanya perlu membangun 2 sesi iBGP ke Loopback `RR-Edge-1` dan `RR-Edge-2`.

---

## 2. Tabel Pengalamatan IP (IP Addressing)

| Perangkat | Peran | Loopback (`lo`) | Link Upstream / eBGP | Link Internal / OSPF |
| :--- | :--- | :--- | :--- | :--- |
| **RR-Edge-1** | Edge + RR-1 (`AS 6500`) | `10.255.255.1/32` | `ether1`: `25.255.255.2/30` (to AS 100) | `ether2`: `172.16.10.1/30`<br>`ether3`: `172.16.1.1/30`<br>`ether4`: `30.30.30.1/30` |
| **RR-Edge-2** | Edge + RR-2 (`AS 6500`) | `10.255.255.2/32` | `ether1`: `14.14.14.1/30` (to AS 200) | `ether2`: `172.16.10.2/30`<br>`ether3`: `172.16.30.1/30`<br>`ether4`: `12.12.12.1/30` |
| **Core-1** | Core / RR-Client | `10.255.255.3/32` | - | `ether1`: `172.16.1.2/30`<br>`ether2`: `12.12.12.2/30` |
| **Core-2** | Core / RR-Client | `10.255.255.4/32` | - | `ether1`: `30.30.30.2/30`<br>`ether2`: `172.16.30.2/30` |
| **Core-3** | Distribution / RR-Client | `10.255.255.5/32` | - | OSPF Backbone (`16.16.1.0/30`, dll.) |
| **Core-4** | Distribution / RR-Client | `10.255.255.7/32` | - | OSPF Backbone (`15.15.1.0/30`, dll.) |
| **Core-LAN** | Access/Edge LAN / RR-Client | `10.255.255.6/32` | - | `ether1`: `16.16.1.2/30`<br>`ether2`: `15.15.15.2/30` |

---

## 3. Fitur Teknis Utama yang Diimplementasikan

1. **BGP Dynamic Peering (`listen=yes`):** Mengeliminasi kebutuhan penambahan manual setiap *peer* baru di sisi Route Reflector cukup dengan satu aturan `remote.address=10.255.255.0/24`.
2. **Next-Hop-Self & Default Originate:** Kedua router Edge mendistribusikan *default route* (`0.0.0.0/0`) ke seluruh internal AS 6500 (`output.default-originate=always`) dan memaksa *next-hop* ke IP Loopback masing-masing (`nexthop-choice=force-self`).
3. **High Availability (Control Plane & Data Plane):**
   * *Control Plane Redundancy:* Kegagalan pada `RR-Edge-1` otomatis diambil alih oleh `RR-Edge-2` tanpa memutus sesi BGP router *client*.
   * *Data Plane Redundancy (ECMP):* Kegagalan jalur fisik antar-core otomatis dialihkan oleh OSPF melalui jalur cadangan diagonal.
4. **Loopback Isolation (Security Best Practice):** Subnet Loopback internal (`10.255.255.0/24`) diisolasi dari internet publik dan menggunakan `Source NAT (Masquerade)` pada interface eBGP untuk kebutuhan akses keluar perangkat internal.

---

## 4. Struktur Repositori

* `topology/` — Diagram visual topologi PNETLab.
* `configs/` — Skrip konfigurasi bersih RouterOS v7 (`.rsc`) yang dikelompokkan berdasarkan peran (`edge-rr`, `core`, `distribution`).
* `verification/` — Bukti *output* CLI untuk status sesi BGP *Established*, pantulan tabel routing, *traceroute*, dan uji *failover*.
* `docs/` — Catatan arsitektur mengenai perbandingan *Full-Mesh* vs *Route Reflector* dan isolasi keamanan *control plane*.
