# Firewalls

Details regarding firewall configuration within the homeprodlab ;P

## Packet Firewalling, Intrusion Detection, and Routing

The playbook for provisioning a firewall on the network deploys a collection of roles to the host.

The `nftables-firewall` role in this repository tunes kernel parameters to allow the system to route packets between its interfaces.
The role also install the nftables rules file, which I prefer to modify by hand when modifications are needed.

The `fail2ban` role installs the daemon and configures it to monitor for attacks against the ssh daemon and alter nftables to block hosts.

## High-Availability

The `keepalived` daemon maintains control over the VIP used as the default gateway assigned by dhcp in all subnets.
`keepalived` also monitors the service status of critical services

The `kea-dhcpx` daemons are configured for bidirectional high-availability allowing them to share lease records between eachother.

## Additional features

Firewalls on the network also act as tang secret stores for network bound disk encryption, allowing the kubernetes nodes and nas server to re/boot without intervention, provided firewalls are also available.
*Note*: User intervention will be required to decrypt the hypervisor's internal drives.