# nz-mikrotik-config

<p class="callout info">**Requirements:**  
- RouterOS  
- **nz-mikrotik-config.rsc** *([see .rsc](https://github.com/IMAG0D/Toolbox/tree/main/.rsc))*  
</p>

This script can be used in a Mikrotik (or any router with RouterOS) to configure and setup a local network suitable for a typical fibre connection in NZ where VLAN10 and DHCP is required. The network will be configured with the following:

- Ether 1 = WAN
- Ether 2 = LAN
- VLAN ID = 10
- DHCP server setup
- Local Subnet = 192.168.88.25-192.168.88.250
- DNS set to 8.8.8.8

<p class="callout warning">Note, this config does not include any firewall or nat rules!  
<span style="color: rgb(0, 0, 0);">See **nz-mikrotik-firewall.rsc** *(see .rsc)* for those</span></p>

*<span style="color: rgb(0, 0, 0);">In combination with **nz-mikrotik-firewall.rsc** (see .rsc), you should have access to the internet with a great beginner level firewall</span>*