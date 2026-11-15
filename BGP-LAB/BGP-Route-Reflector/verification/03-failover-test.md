---

### 3. `verification/03-failover-test.md`

```markdown
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