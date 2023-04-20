#!/bin/bash

# Verifica se o usuário forneceu uma porta como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 [porta]"
    exit 1
fi

# Varre todos os endereços IP possíveis na rede local
for ip in $(seq 1 254); do
    host="192.168.1.$ip"
    nmap -p "$1" "$host" | grep -q "open"
    if [ $? -eq 0 ]; then
        echo "$host possui a porta $1 aberta"
    fi
done
