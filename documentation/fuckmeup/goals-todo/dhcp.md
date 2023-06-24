# Netbox integrated DHCP

Ansible plays to provision, deprovision, and reconcile DHCP allocations

- Static MAC:IP allocation
  - for subnets tagged with 'dhcp' create static DHCP allocation entries
  - deduplicate in instances where an IP associated with a MACaddr has been changed
- Dynamic address ranges
  - {{ address_range | tagged_with('dhcp') }}
