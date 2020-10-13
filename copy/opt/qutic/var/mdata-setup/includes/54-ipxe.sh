#!/bin/bash

# setup dhcpd
IP=$(ifconfig net0 |grep 'inet ' |awk '{print $2}')
SUBNET=$(echo ${IP} | cut -d"." -f1-3)
sed -i \
    -e "s/next-server 10.10.10.58;/next-server ${IP};/" \
    -e "s|subnet 10.10.10.0|subnet ${SUBNET}.0|" \
    -e "s|range 10.10.10.240 10.10.10.249;|range 1${SUBNET}.240 ${SUBNET}.249;|" \
    /opt/local/etc/dhcp/dhcpd.conf
svcadm enable svc:/pkgsrc/isc-dhcpd:default
# svcadm restart svc:/pkgsrc/isc-dhcpd:default

# setup ipxe
sed -i \
    -e "s|set remote-root http://10.10.10.58|set remote-root http://${IP}|" \
    /var/www/default/ipxe/bootstrap.ipxe
