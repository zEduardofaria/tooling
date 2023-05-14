#!/bin/bash

# Get the first 3 parts of the IP address from the user
ip_address=$1

# Get the range of the block of IP addresses from the user
block_start=$2
block_end=$3

# Check if any of the parameters are missing
if [ -z "$ip_address" ] || [ -z "$block_start" ] || [ -z "$block_end" ]; then

  # Print an error message
  echo "Error: One or more parameters are missing."
  echo "Usage: $0 <ip_address> <block_start> <block_end>"
  exit 1

fi

# Loop throught the range of IP addresses
for ip in $(seq $block_start $block_end); do

  # Print the PTR record for the current IP address
  host -t ptr $ip_address.$ip

done