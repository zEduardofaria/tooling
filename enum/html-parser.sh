#!/bin/bash

if [ "$1" = "--help" ]; then
  echo "Usage: $0 [domain] [--only-address] [--only-ip]"
  echo "  --only-address: display only the list of new addresses found"
  echo "  --only-ip: display only a list of IP addresses of the domains found"
  echo "Exiting."
  exit 0
fi

if [ -z "$1" ]; then
  echo "Usage: $0 [dominio]"
  exit 1
fi

domain="$1"

echo "==============================================================================="
echo "                                    [+] URLs in: [$domain]"
echo "==============================================================================="
printf "%-6s%-50s%s\n" "Line" "Address" "IP"
echo "==============================================================================="

count=0
urls=""
ips=""

while read line; do
  ip=$(host "$(echo "$line" | cut -c8-)" | awk '/has address/ { print $4 }')
  printf "%-6s%-50s%-15s\n" "$count" "$line" "$ip"
  urls+="$line\n"
  ips+="$ip\n"
  ((count++))
done < <(wget -q -O - "$domain" | grep -Eoi '<a [^>]+>' | \
grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^/"]+')
echo "==============================================================================="

if [ "$2" = "--only-address" ]; then
  echo "==============================================================================="
  echo "                                    [+] Listing only new addresses"
  echo "==============================================================================="
  echo -e "$urls"
  exit 0
fi

if [ "$2" = "--only-ip" ]; then
  echo "==============================================================================="
  echo "                                    [+] Listing only IPs"
  echo "==============================================================================="
  echo -e "$ips"
  exit 0
fi