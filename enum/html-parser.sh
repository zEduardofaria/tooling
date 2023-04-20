#!/bin/bash

if [ -z "$1" ]; then
  echo "Uso: $0 [dominio]"
  exit 1
fi

domain="$1"

echo "==============================================================================="
echo "                                    [+] Resolvendo URLs em: [$domain]           "
echo "==============================================================================="
printf "%-6s%-50s%s\n" "Line" "Novo Endereço" "IP"
echo "--------------------------------------------------------------------------------"

count=0
wget -q -O - "$domain" | grep -Eoi '<a [^>]+>' | \
grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^/"]+' | \
while read line; do
  ip=$(host "$(echo "$line" | cut -c8-)" | awk '/has address/ { print $4 }')
  printf "%-6s%-50s%-15s\n" "$count" "$line" "$ip"
  ((count++))
done