
Interface configuration using `nmcli`:

```shell
# Create the bridge interfaces
sudo nmcli con add ifname vm-br-wan type bridge con-name vm-br-wan
sudo nmcli con add ifname vm-br-vl10 type bridge con-name vm-br-vl10
sudo nmcli con add ifname vm-br-vl20 type bridge con-name vm-br-vl20
sudo nmcli con add ifname vm-br-vl30 type bridge con-name vm-br-vl30
# Create VLAN interfaces
sudo nmcli con add ifname eno8.10 type vlan con-name eno8.10 dev eno8 id 10
sudo nmcli con add ifname eno8.20 type vlan con-name eno8.20 dev eno8 id 20
sudo nmcli con add ifname eno8.30 type vlan con-name eno8.30 dev eno8 id 30
# Bind the bridge interfaces to the physical interface
sudo nmcli con mod eno2 master vm-br-wan slave-type bridge
sudo nmcli con mod eno8.10 master vm-br-vl10 slave-type bridge
sudo nmcli con mod eno8.20 master vm-br-vl20 slave-type bridge
sudo nmcli con mod eno8.30 master vm-br-vl30 slave-type bridge
# Enable Spanning Tree on the bridges
sudo nmcli con mod vm-br-wan bridge.stp yes
sudo nmcli con mod vm-br-vl10 bridge.stp yes
sudo nmcli con mod vm-br-vl20 bridge.stp yes
sudo nmcli con mod vm-br-vl30 bridge.stp yes
```

Should produce results like:

```none
{ λ elliana@SYS-5019D:~ }={% ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno5: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c2 brd ff:ff:ff:ff:ff:ff
    altname enp181s0f0
    altname ens9f0
3: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:76:8e brd ff:ff:ff:ff:ff:ff
    altname enp101s0f0
4: eno6: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c3 brd ff:ff:ff:ff:ff:ff
    altname enp181s0f1
    altname ens9f1
5: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master vm-br-wan state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:76:8f brd ff:ff:ff:ff:ff:ff
    altname enp101s0f1
6: eno7: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c4 brd ff:ff:ff:ff:ff:ff
    altname enp181s0f2
    altname ens9f2
7: eno8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c5 brd ff:ff:ff:ff:ff:ff
    altname enp181s0f3
    altname ens9f3
8: eno3: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:76:90 brd ff:ff:ff:ff:ff:ff
    altname enp101s0f2
9: eno4: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:76:91 brd ff:ff:ff:ff:ff:ff
    altname enp101s0f3
45: eno8.30@eno8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master vm-br-vl30 state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c5 brd ff:ff:ff:ff:ff:ff
46: vm-br-vl30: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c5 brd ff:ff:ff:ff:ff:ff
47: eno8.10@eno8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master vm-br-vl10 state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c5 brd ff:ff:ff:ff:ff:ff
48: vm-br-vl10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c5 brd ff:ff:ff:ff:ff:ff
49: eno8.20@eno8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master vm-br-vl20 state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c5 brd ff:ff:ff:ff:ff:ff
50: vm-br-vl20: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:70:c5 brd ff:ff:ff:ff:ff:ff
54: vm-br-wan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 3c:ec:ef:41:76:8f brd ff:ff:ff:ff:ff:ff
```

Configuration template for libvirt networks:

```xml
<network>
  <name>{{ bridge_intf_name }}</name>
  <forward mode="bridge"/>
  <bridge name="{{ bridge_intf_name }}"/>
</network>
```

You'll need to create one for each bridge you want to bind VM interfaces to.