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
# Firewall Rules
# 1. accept established,related,untracked
# 2. drop invalid" connection-state=invalid
# 3. accept ICMP
# 4. accept to local loopback (for CAPsMAN)
# 5. drop all not coming from LAN
# 6. fasttrack
# 7. accept established,related,untracked
# 8. drop invalid
# 9. drop all from WAN not DSTNATed
# ***NAT Masquerade rule added
#
# --- BEGIN SCRIPT ---

/ip firewall filter
add action=accept chain=input comment="accept established,related,untracked" \ connection-state=established,related,untracked
add action=drop chain=input comment="drop invalid" \ connection-state=invalid
add action=accept chain=input comment="accept ICMP" \ protocol=icmp
add action=accept chain=input comment="accept to local loopback (for CAPsMAN)" \  dst-address=127.0.0.1
add action=drop chain=input comment="drop all not coming from LAN" \ in-interface-list=!LAN
add action=fasttrack-connection chain=forward comment="fasttrack" \ connection-state=established,related
add action=accept chain=forward comment="accept established,related, untracked" \ connection-state=established,related,untracked
add action=drop chain=forward comment="drop invalid" \ connection-state=invalid
add action=drop chain=forward comment="drop all from WAN not DSTNATed" \ connection-nat-state=!dstnat connection-state=new in-interface-list=WAN

/ip firewall nat
add action=masquerade chain=srcnat comment=masquerade ipsec-policy=out,none \ out-interface-list=WAN

# --- END SCRIPT ---