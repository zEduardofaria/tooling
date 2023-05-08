#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 domain.com"
  exit 1
fi

# Get the list of name servers for the domain
ns_records=$(host -t ns "$1" | grep "name server" | awk '{print $NF}' | sed 's/\.$//')

# Loop through the name servers and find their associated records
for ns in $ns_records; do
  echo "Subdomains for $ns:"
  host -l -a "$1" "$ns"
done
