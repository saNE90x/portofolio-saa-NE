# PCC Load Balancing

## 1. Overview

This project demonstrates the implementation of **Per Connection Classifier (PCC) Load Balancing** using MikroTik CHR in a virtual network environment.

PCC is a load balancing method that distributes network connections across multiple WAN connections based on a classification algorithm.

The purpose of this implementation is to distribute traffic across multiple internet gateways, improve bandwidth utilization, and provide a more balanced network connection.

## 2. Objectives

- Implement PCC Load Balancing on MikroTik RouterOS.
- Distribute network connections across multiple WAN gateways.
- Configure connection and routing marks using firewall mangle.
- Configure NAT for outbound traffic.
- Verify traffic distribution across WAN connections.
- Analyze the behavior of the load balancing mechanism.

## 3. Lab Environment

| Component | Description |
|---|---|
| Network Simulator | PNetLab |
| Router Platform | MikroTik CHR |
| Operating System | RouterOS 7 |
| Feature | PCC Load Balancing |
| WAN Connections | Multiple WAN Links |

## 4. Network Topology

The lab topology consists of a MikroTik router connected to multiple WAN gateways and a LAN network.

![Network Topology](screenshots/topology.png)

### Network Overview

- **WAN 1:** Primary internet connection.
- **WAN 2:** Secondary internet connection.
- **LAN:** Internal network used by client devices.
- **MikroTik CHR:** Performs PCC classification, routing, and NAT.

## 5. Configuration

### 5.1 Configuration Overview

The implementation involves the following configurations:

1. **Interface Configuration**  
   Assign interfaces for WAN and LAN connections.

2. **IP Addressing**  
   Configure IP addresses for each network segment.

3. **Firewall Mangle**  
   Apply PCC classification to distribute connections across WAN links using connection marks and routing marks.

4. **Routing Configuration**  
   Configure routing policies to direct marked traffic through the appropriate WAN gateway.

5. **NAT Configuration**  
   Configure source NAT or masquerade for outbound traffic.

### 5.2 Configuration File

The complete MikroTik RouterOS configuration is available here:

[`configuration.rsc`](configuration.rsc)

### 5.3 Key Configuration Explanation

| Configuration | Purpose |
|---|---|
| PCC Classifier | Distributes connections across WAN links |
| Connection Mark | Identifies and marks network connections |
| Routing Mark | Directs traffic through the selected routing table |
| Default Route | Defines the gateway for each WAN connection |
| NAT | Enables LAN clients to access external networks |

## 6. Verification

The following commands can be used to verify the configuration.

**Check Mangle Rules**

```routeros
/ip firewall mangle print stats
```

**Check Routing Tables**

```routeros
/routing table print
```

**Check Active Routes**

```routeros
/ip route print detail
```

**Check NAT Rules**

```routeros
/ip firewall nat print
```

![Verification](screenshots/verification.png)

## 7. Testing & Results

The following test scenarios are used to verify the PCC implementation.

| Test Scenario | Expected Result |
|---|---|
| Multiple client connections | Connections are distributed across WAN links |
| WAN 1 traffic test | Traffic is routed through WAN 1 |
| WAN 2 traffic test | Traffic is routed through WAN 2 |
| Multiple simultaneous connections | Traffic distribution follows the configured PCC classifier |

### Testing Evidence

![PCC Testing](screenshots/pcc-testing.png)

**Test Result:**  
[Describe the actual test results and observations here.]

## 8. Conclusion

This project demonstrates how PCC Load Balancing can be implemented using MikroTik RouterOS.

By using connection marking, routing marking, and multiple routing gateways, network traffic can be distributed across multiple WAN connections.

This lab provides practical experience in MikroTik firewall mangle, policy-based routing, and multi-WAN network management.
