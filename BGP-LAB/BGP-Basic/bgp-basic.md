# BGP Enterprise to ISP Lab Series (MikroTik RouterOS v7)

A progressive, hands-on Border Gateway Protocol (BGP) lab series built on **PNETLab** using **MikroTik CHR (RouterOS v7)**. Starting from a foundational dual-homed setup, this repository documents step-by-step implementations of enterprise-to-ISP routing policies, traffic engineering, and route security using a single unified topology.

---

## Master Topology
![Master BGP Topology](bgp-basic-topology.png)

### Infrastructure & AS Design
* **Enterprise Network (`AS 6500`):** Dual-homed architecture with two edge routers (`R-1 Edge`, `R-1 Edge-1`) and one core router (`R-1 Edge-2`), utilizing **OSPF** as an IGP underlay for Loopback-based **iBGP** peering.
* **Primary Transit (`AS 100`):** `ISP-Primary` providing primary upstream connectivity.
* **Backup Transit (`AS 200`):** `ISP-Backup` providing redundant failover connectivity.
* **Internet Upstream (`AS 300`):** `Upstream` simulating global internet prefixes (`3.3.3.3/32`, `0.0.0.0/0`).

| Device | Role | ASN | Loopback (`lo`) | Connected Subnets |
| :--- | :--- | :--- | :--- | :--- |
| **Upstream** | Internet Upstream | `300` | `3.3.3.3/32` | `13.13.13.0/30`, `23.23.23.0/30` |
| **ISP-Primary** | Primary ISP | `100` | `1.1.1.1/32` | `13.13.13.0/30`, `10.1.1.0/30` |
| **ISP-Backup** | Backup ISP | `200` | `2.2.2.2/32` | `23.23.23.0/30`, `10.2.2.0/30` |
| **R-1 Edge** | Edge Router 1 | `6500` | `10.255.255.1/32` | `10.1.1.0/30`, `10.65.13.0/30` |
| **R-1 Edge-1** | Edge Router 2 | `6500` | `10.255.255.2/32` | `10.2.2.0/30`, `10.65.23.0/30` |
| **R-1 Edge-2** | Core Router | `6500` | `10.255.255.3/32` | `10.65.13.0/30`, `10.65.23.0/30`, `103.10.10.0/24` |

---
