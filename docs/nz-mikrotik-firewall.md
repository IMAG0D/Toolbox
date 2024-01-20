# nz-mikrotik-firewall

Requirements:

- RouterOS
- nz-mikrotik-firewall.rsc ([see .rsc](https://github.com/IMAG0D/Toolbox/tree/main/.rsc))

This script can be used in a Mikrotik (or any router with RouterOS) to configure and setup a firewall as well as nat masquerading. When run in sequence with nz-mikrotik-config.rsc (see .rsc) you will have a complete router setup that allow internet connection with basic network security.

Firewall Rules (in order)

1. accept established,related,untracked
2. drop invalid" connection-state=invalid
3. accept ICMP
4. accept to local loopback (for CAPsMAN)
5. drop all not coming from LAN
6. fasttrack
7. accept established,related,untracked
8. drop invalid
9. drop all from WAN not DSTNATed

- NAT Masquerade rule added

Notes:

PLEASE MAKE SURE TO ADD A FIREWALL