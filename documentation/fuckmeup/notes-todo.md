# Home Network

## Project Taskboard

### ( RPi-EdgeFW ) Basic SOHO

1. Interfaces configuration
    - STATUS:: Operational, Controlled by Ansible, could use revision.
2. Routing Protocols
    - STATUS:: BIRD-BGPd Operational.
3. Packet Filtering and NAT
    - STATUS:: NFTables, Operational but occasional kinks.
4. DHCP and DNS
    - STATUS:: PiHole/DHCPd Operational, DNS not-enforced.
5. Remote Access VPN
    - STATUS: Wireguard Not Installed.

### ( RPi-EdgeFW ) IDP/S Firewall

1. Suricata
    - Used for logging problematic and suspicious traffic.
    - STATUS:: Configured and running, not dropping.
1. Elasticsearch and Kibana
    - STATUS:: Not Installed
1. Fluent Bit
    - STATUS:: Not Installed

### Kubernetes Cluster

- Cool Wiki
- Intel GPU
- Stats

### Network Authentication

1. Identity server
    - Planning to implement PacketFence and FreeIPA, Will use one of the Raspberry Pi's
    - Provide 802.1x and RADIUS authentication possibly Kerberos as well, not fully familiar with Directory systems in linux
    - STATUS:: Not Installed
2. Unifi Controller
    - Will use same Pi as the Identity Server
