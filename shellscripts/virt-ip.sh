#!/bin/bash

ssh 192.168.1.2 arp -an | grep "`virsh dumpxml $1 | grep "mac address" | sed "s/.*'\(.*\)'.*/\1/g"`" | awk '{ gsub(/[\(\)]/,"",$2); print $2 }'
