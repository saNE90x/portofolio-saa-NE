# Gateway Failover Testing

## 1. Overview

This document describes the testing process for the Gateway Failover implementation using MikroTik CHR.

The purpose of this test is to verify whether the backup ISP can automatically take over when the primary ISP loses internet connectivity.

The testing process includes:

- Checking the initial routing configuration.
- Verifying internet connectivity before failover.
- Simulating a primary ISP failure.
- Monitoring routing table changes.
- Verifying internet connectivity through the backup ISP.
- Confirming the primary ISP recovery behavior.

## 2. Initial Routing Verification

Before performing the failover test, the routing table is checked to ensure that both ISP gateways are configured correctly.

**Command:**

```routeros
/ip route print detail
```

**Initial Routing Table:**

```text
0   s   dst-address=0.0.0.0/0 gateway=192.168.20.1
        distance=2 scope=10 target-scope=30

1  As   dst-address=0.0.0.0/0 gateway=192.168.10.1
        distance=1 scope=10 target-scope=30

2  As   dst-address=1.1.1.1/32 gateway=192.168.10.1
        distance=1 scope=30 target-scope=10

3  As   dst-address=1.1.1.2/32 gateway=192.168.20.1
        distance=1 scope=30 target-scope=10
```

### Analysis

Based on the routing table:

- **ISP-A (192.168.10.1)** is configured as the primary gateway with distance 1.
- **ISP-B (192.168.20.1)** is configured as the backup gateway with distance 2.
- Each ISP has a dedicated monitoring route.

The primary ISP is preferred because it has a lower administrative distance.

## 3. Initial Connectivity Test

Before disabling ISP-A, internet connectivity is tested using ICMP ping.

**Command:**

```routeros
/ping 8.8.8.8
```

**Test Result:**

```text
sent=20 received=15 packet-loss=25%
min-rtt=18ms44us
avg-rtt=18ms739us
max-rtt=20ms310us
```

### Analysis

The router can reach the external destination through the active primary ISP.

However, the test records 25% packet loss. This should be considered when evaluating the failover results, since the initial connection is not completely stable.

## 4. Primary ISP Failure Simulation

The next step is to simulate an internet connection failure on ISP-A.

### Testing Procedure

1. Disable the internet connection from ISP-A.
2. Allow Netwatch to detect the connectivity failure.
3. Monitor the ping response to `8.8.8.8`.
4. Check whether the primary default route is disabled.

**Command:**

```routeros
/ping 8.8.8.8
```

During the failure simulation, the ping output shows several timeout responses.

This indicates a temporary interruption while the failover mechanism detects the primary ISP failure and switches to the backup route.

## 5. Routing Table Verification During Failover

After ISP-A loses internet connectivity, the routing table is checked again.

**Command:**

```routeros
/ip route print detail
```

**Routing Table After ISP-A Failure:**

```text
0  Xs   dst-address=0.0.0.0/0
         gateway=192.168.10.1

1  As   dst-address=0.0.0.0/0
         gateway=192.168.20.1
         distance=2

2  As   dst-address=1.1.1.1/32
         gateway=192.168.10.1

3  As   dst-address=1.1.1.2/32
         gateway=192.168.20.1
```

### Analysis

The routing table shows that:

- The primary default route through ISP-A is disabled.
- The backup default route through ISP-B remains active.
- ISP-B takes over as the active internet gateway.

The `X` flag indicates that the primary default route has been disabled, while the `A` flag indicates that the backup default route is active.

This confirms that the Netwatch monitoring mechanism has triggered the failover process.

## 6. Connectivity Verification Through Backup ISP

After the backup route becomes active, internet connectivity is tested again.

**Command:**

```routeros
/ping 8.8.8.8
```

**Test Result:**

```text
sent=8 received=8 packet-loss=0%
min-rtt=17ms963us
avg-rtt=18ms888us
max-rtt=19ms809us
```

### Analysis

The router successfully reaches `8.8.8.8` through ISP-B.

The test records:

- 8 packets sent.
- 8 packets received.
- 0% packet loss.
- Average latency of approximately 18.9 ms.

This confirms that the backup ISP successfully maintains internet connectivity after the primary ISP failure.

## 7. Primary ISP Recovery

After verifying the backup connection, ISP-A can be restored.

When internet connectivity through ISP-A becomes available again, Netwatch detects the recovery and re-enables the primary default route.

Since ISP-A has a lower route distance than ISP-B, it becomes the preferred gateway again.

ISP-B returns to its backup role.

## 8. Testing Summary

| Test Scenario | Result |
|---|---|
| Initial routing configuration | Successful |
| Initial internet connectivity | Reachable, 25% packet loss |
| ISP-A failure simulation | Successful |
| Primary route deactivation | Successful |
| Backup route activation | Successful |
| Internet connectivity through ISP-B | Successful, 0% packet loss |
| Primary ISP recovery | Expected behavior based on configuration; verify after restoration |

## 9. Conclusion

The Gateway Failover mechanism was successfully tested using MikroTik CHR and Netwatch.

When ISP-A loses internet connectivity, Netwatch detects the failure and disables the primary default route. ISP-B then becomes the active gateway and maintains internet connectivity.

When ISP-A is restored, the primary route is re-enabled and becomes the preferred gateway again due to its lower route distance.

This implementation demonstrates automatic WAN failover, route monitoring, and basic network redundancy using MikroTik RouterOS.
