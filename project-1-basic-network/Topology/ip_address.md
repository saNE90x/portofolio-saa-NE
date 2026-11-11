# IP Addressing & VLAN Segmentation

## 1. Overview

The network infrastructure uses VLAN segmentation to separate network traffic into different logical network segments.

Three VLANs are implemented in this project, each assigned to a different IP subnet to provide network separation and structured IP addressing.

## 2. VLAN Configuration

| VLAN ID | Network Segment | IP Subnet | Gateway |
|---|---|---|---|
| VLAN 10 | [Karyawan] | [192.168.57.1/24] | [192.168.57.1] |
| VLAN 20 | [HR] 	   | [192.168.80.1/24] | [192.168.80.1] |
| VLAN 30 | [Manager]  | [192.168.30.1/24] | [192.168.30.1] |

## 3. Network Segmentation

Each VLAN operates within its own IP subnet. This allows network traffic to be logically separated and managed independently.

Inter-VLAN communication is handled through the configured routing mechanism.

## 4. Notes

- Each VLAN uses a separate IP subnet.
- VLAN segmentation provides logical network separation.
- Gateway addresses are assigned according to the network design.
