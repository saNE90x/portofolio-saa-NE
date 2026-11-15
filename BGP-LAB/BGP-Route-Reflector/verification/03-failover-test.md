# 03. Verifikasi Konektivitas End-to-End & Skenario Failover

## 1. Uji Konektivitas Data Plane (`Core-LAN` $\longrightarrow$ `Upstream 1.1.1.1`)

### Ping Test dari Router Ujung Dalam (`Core-LAN`)
```routeros
[admin@Core-LAN] > ping 1.1.1.1
  SEQ HOST                                     SIZE TTL TIME       STATUS
    0 1.1.1.1                                    56  60 8ms919us
    1 1.1.1.1                                    56  60 9ms526us
    2 1.1.1.1                                    56  60 8ms983us
    3 1.1.1.1                                    56  60 8ms218us
    sent=4 received=4 packet-loss=0% min-rtt=8ms218us avg-rtt=8ms911us max-rtt=9ms526us
```

### Traceroute Jalur Paket (`src-address=10.255.255.6`)
```routeros
[admin@Core-LAN] > tool/traceroute 1.1.1.1 src-address=10.255.255.6
Columns: ADDRESS, LOSS, SENT, LAST, AVG, BEST, WORST, STD-DEV
#  ADDRESS     LOSS  SENT  LAST   AVG  BEST  WORST  STD-DEV
1  15.15.15.1  0%       8  2ms    1.9  1.6   2.1    0.2    
2  11.1.1.1    0%       8  3.8ms  4    3     6.2    0.9    
3  172.16.1.1  0%       8  4.9ms  5.4  4.6   7.3    0.9    
4  25.25.25.1  0%       8  6.8ms  6.8  6.4   7.2    0.2    
5  1.1.1.1     0%       8  7.6ms  9.5  7.6   12.1   1.6    
```

**Penelusuran Hop:**
1. `15.15.15.1` (`Core-4`) — Pintu keluar pertama dari `Core-LAN`.
2. `11.1.1.1` (`Core-2`) — Diteruskan ke layer *Core*.
3. `172.16.1.1` (`RR-Edge-1`) — Melintasi jalur silang menuju Edge Router utama (`AS 6500`).
4. `25.25.25.1` (`ISP-Primary`) — Keluar melalui peering eBGP menuju `AS 100`.
5. `1.1.1.1` (`Upstream`) — Tiba di Loopback router `Upstream` (`AS 350`) dengan `0% packet loss`.

---

## 2. Matriks Pengujian Ketahanan (*High Availability & Failover*)

| Skenario Uji | Tindakan Simulasi | Perilaku Sistem & Hasil Verifikasi | Status |
| :--- | :--- | :--- | :--- |
| **Control Plane Failover (RR-1 Down)** | Menonaktifkan sesi iBGP / mematikan node `RR-Edge-1` (`10.255.255.1`). | Seluruh *RR-Client* tetap mempertahankan sesi `Established` ke `RR-Edge-2` (`10.255.255.2`). Rute `0.0.0.0/0` otomatis berpindah menjadi `DAb` via `10.255.255.2` (ISP-Backup `AS 200`). | **PASS** |
| **Physical Link Failover (OSPF Underlay)** | Memutus (*suspend*) kabel fisik utama `ether2` (`15.15.15.0/30`) antara `Core-LAN` dan `Core-4`. | OSPF langsung mengalihkan jalur keluar ke `ether1` (`16.16.1.1` via `Core-3`) dalam hitungan detik. Sesi TCP iBGP ke kedua RR tetap menyala tanpa *reset*. | **PASS** |
| **Security Isolation (Loopback Protection)** | Menguji akses dari `Upstream` (`AS 350`) ke subnet Loopback internal (`10.255.255.0/24`). | Subnet `10.255.255.0/24` tidak di-advertise ke eBGP publik dan terlindungi oleh `Source NAT` pada Edge Router, mencegah akses langsung ke *control plane* router internal. | **PASS** |