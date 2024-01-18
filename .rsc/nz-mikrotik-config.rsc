# -----------------------------------------------------
# -----------------------------------------------------
#    _____  .__ __                ___________.__ __    
#   /     \ |__|  | _________  ___\__    ___/|__|  | __
#  /  \ /  \|  |  |/ /\_  __ \/  _ \|    |   |  |  |/ /
# /    Y    \  |    <  |  | \(  <_> )    |   |  |    < 
# \____|__  /__|__|_ \ |__|   \____/|____|   |__|__|_ \
#         \/        \/                               \/
# -----------------------------------------------------
# -----------------------------------------------------
#
# Ether 1 = WAN
# Ether 2 = LAN
# VLAN ID = 10
# DHCP server setup
# Local Subnet = 192.168.88.25-192.168.88.250
# DNS set to 8.8.8.8
#
# --- BEGIN SCRIPT ---
#
# Uncomment and run line separately if factory reset is needed
# /system/reset-configuration no-defaults=yes

/interface bridge
add name=bridge1

/interface vlan
add interface=ether1 name=vlan10 vlan-id=10

/interface list
add name=WAN
add name=LAN

/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik

/ip pool
add name=dhcp_pool0 ranges=192.168.88.25-192.168.88.250

/ip dhcp-server
add address-pool=dhcp_pool0 interface=bridge1 lease-time=1h name=dhcp1

/port
set 0 name=serial0

/interface list member
add interface=vlan10 list=WAN
add interface=bridge1 list=LAN

/ip address
add address=192.168.88.1/24 interface=bridge1 network=192.168.88.0

/ip dhcp-client
add interface=vlan10

/ip dhcp-server network
add address=192.168.88.0/24 dns-server=8.8.8.8 gateway=192.168.88.1

/ip dns
set allow-remote-requests=yes

/interface bridge port
add bridge=bridge1 interface=ether2
# Add additional ports to the bridge as needed
# add brindge=bridge1 interface=XXX

# --- END SCRIPT ---