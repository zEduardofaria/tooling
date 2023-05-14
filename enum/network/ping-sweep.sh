#!/bin/bash

# Verifica se o usuário forneceu um endereço IP como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 [endereço IP]"
    exit 1
fi

# Extrai o prefixo do endereço IP
prefix=$(echo "$1" | cut -d "." -f 1-3)

# Inicializa uma variável para armazenar os endereços IP ativos
ativos=""

# Varre todos os endereços IP possíveis no prefixo
for i in {1..254}; do
    ip="$prefix.$i"
    ping -c 1 "$ip" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        ativos="$ativos\n$ip"
    fi
done

# Imprime a lista de endereços IP ativos
echo -e "Endereços IP ativos:\n$ativos"