# Gateway Failover

## 1. Overview

Gateway Failover is a network redundancy mechanism designed to maintain internet connectivity when the primary gateway becomes unavailable.

In this project, Gateway Failover is implemented using MikroTik CHR in a virtual network environment (PNetLab).

The implementation uses a primary and backup gateway to provide automatic route switching during network failures.

## 2. Objectives

The objectives of this implementation are:

- Implement gateway redundancy using MikroTik RouterOS.
- Configure primary and backup gateway routes.
- Maintain network connectivity during gateway failures.
- Understand automatic route switching and recovery mechanisms.
- Perform connectivity testing under different network conditions.

## 3. Lab Environment

| Component | Description |
|---|---|
| Platform | PNetLab |
| Network Device | MikroTik CHR |
| Operating System | MikroTik RouterOS |
| Technology | Gateway Failover |

## 4. Network Topology

![Gateway Failover Topology](screenshots/topology.png)

**Topology Description:**

The network consists of a MikroTik router connected to two upstream gateways.

- Primary Gateway: Main internet connection.
- Backup Gateway: Alternative internet connection used when the primary gateway becomes unavailable.
- LAN: Internal network used by client devices.

## 5. Configuration

### 5.1 Configuration Overview

Gateway Failover is configured using routing mechanisms to determine the preferred gateway and automatically switch to an alternative route when the primary path becomes unavailable.

### 5.2 Configuration File

The complete MikroTik configuration is available in:

`configuration.rsc`

### 5.3 Key Configuration Explanation

The main configuration includes:

- IP addressing and interface configuration.
- Primary gateway routing.
- Backup gateway routing.
- Route priority and distance.
- Gateway reachability monitoring.

## 6. Verification

The following commands are used to verify the routing configuration:

```routeros
/ip route print detail
/ip route print where active
/ip address print
/ping [gateway-address]
```

**Verification Evidence:**

![Routing Verification](screenshots/verification.png)

## 7. Testing & Results

The following scenarios are used to evaluate the failover mechanism.

| Test Scenario | Expected Result | Actual Result |
|---|---|---|
| Primary gateway active | Traffic uses the primary gateway. | [Test Result] |
| Primary gateway unavailable | Traffic switches to the backup gateway. | [Test Result] |
| Primary gateway restored | Traffic returns to the primary gateway according to the configured routing policy. | [Test Result] |
| Backup gateway unavailable | Primary connection remains operational if available. | [Test Result] |

**Testing Evidence:**

![Failover Testing](screenshots/failover-testing.png)

## 8. Conclusion

This project demonstrates the implementation of Gateway Failover using MikroTik CHR.

Through routing configuration and connectivity testing, the implementation provides practical experience in network redundancy, route selection, and automatic gateway recovery.

The testing process helps verify how the network responds to gateway failures and connection recovery.
