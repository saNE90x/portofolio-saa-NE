Network Infrastructure & Redundancy Implementation

A practical network engineering project developed using PNetLab, focusing on routing, switching, network redundancy, and traffic management.

This project demonstrates the implementation and testing of various networking technologies using MikroTik CHR routers and Cisco IOS switches in a virtual lab environment.

Project Overview

The main objective of this project is to implement and understand networking technologies that improve network availability, reliability, and performance.

The project covers four main implementations:

Technology

Description

Platform / Vendor

PCC Load Balancing

Distributes network connections across multiple WAN gateways.

MikroTik CHR

Gateway Failover

Provides automatic backup routing when the primary gateway becomes unavailable.

MikroTik CHR

Spanning Tree Protocol (STP)

Prevents Layer 2 switching loops in redundant network topologies.

Cisco IOS

Link Aggregation Control Protocol (LACP)

Combines multiple physical links into a logical link for redundancy and increased aggregate capacity.

Cisco IOS

Lab Environment

The entire project is developed and tested in a virtual networking environment.

Lab Platform

PNetLab

Network Devices

MikroTik CHR (Cloud Hosted Router)

Cisco IOS Switch

Technologies

PCC Load Balancing

Gateway Failover

Spanning Tree Protocol (STP)

Link Aggregation Control Protocol (LACP)

Network Topology

The network topology illustrates the relationship between routers, switches, and network connections used throughout the project.



Project Documentation

Detailed documentation, device configurations, and testing evidence are organized into separate directories.

1. PCC Load Balancing

Implementation of Per Connection Classifier (PCC) to distribute network connections across multiple WAN links.

View Documentation

2. Gateway Failover

Implementation of gateway redundancy to maintain network connectivity when the primary gateway fails.

View Documentation

3. Spanning Tree Protocol (STP)

Implementation of STP on Cisco IOS switches to prevent Layer 2 switching loops and manage redundant network paths.

View Documentation

4. Link Aggregation Control Protocol (LACP)

Implementation of LACP to combine multiple Ethernet links between switches into a logical connection.

View Documentation

Repository Structure

## Repository Structure

```text
portofolio-saa/
│
├── README.md
│
└── project-1-basic-network/
    │
    ├── README.md
    │
    ├── Topology/
    │   ├── network-topology.png
    │   └── ip-addressing.md
    │
    ├── PCC-Load-Balancing/
    │   ├── README.md
    │   ├── configuration.rsc
    │   └── screenshots/
    │
    ├── Gateway-Failover/
    │   ├── README.md
    │   ├── configuration.rsc
    │   └── screenshots/
    │
    ├── STP/
    │   ├── README.md
    │   ├── configuration.txt
    │   └── screenshots/
    │
    └── LACP/
        ├── README.md
        ├── configuration.txt
        └── screenshots/
```

Testing & Verification

Each implementation includes configuration verification and practical testing scenarios.

Testing evidence includes:

Device configuration screenshots.

Routing and switching status.

Connectivity verification.

Network redundancy testing.

Link failure and recovery scenarios.

Project Objectives

Develop practical routing and switching skills.

Understand network redundancy mechanisms.

Implement traffic distribution and gateway backup.

Prevent Layer 2 switching loops.

Improve troubleshooting and network analysis skills.

Author

Name: Ghesa Arinza Wibowo

Field: Network Engineering

Focus Areas: Routing, Switching, Network Redundancy, and Troubleshooting
