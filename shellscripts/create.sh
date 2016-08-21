#!/bin/bash

host=`/bin/cat /etc/sysconfig/network | grep mkdata | cut -c10-40`
user=`/bin/cat /etc/passwd | grep 1000 | awk -F: '{print $1}'`

mkdir /mnt/$user
touch /mnt/$user/$host.json

ip_addr=`/sbin/ifconfig eth0 | grep 'inet ' | cut -d: -f2 | awk '{ print $1}'`
mac=`/bin/cat /sys/class/net/eth0/address`
key=$host.pem
/bin/mv /root/*.pem /mnt/$user/

echo "["\"$host\","\"$ip_addr\","\"$key\","\"$mac\"]" >> /mnt/$user/$host.json
echo "$user  ALL=(ALL)      NOPASSWD:ALL" > /etc/sudoers.d/$user

