#!/bin/sh

ipv4classc="${1}"

for IP in $(seq 0 255)
do
	dns_fqdn=$(nslookup ${ipv4classc}.${IP} | awk -F"= " '/name/{print $2}' | head -n 1)
	echo "${ipv4classc}.${IP} -> ${dns_fqdn}"
#	sleep 1
done
