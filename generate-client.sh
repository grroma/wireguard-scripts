#!/bin/bash

# Path for storing client configurations
CLIENTS_DIR="/root/wgard-settings/configs"
SERVER_PUBLIC_KEY="<your_server_public_key>"
SERVER_IP="<your_server_ip>"
SERVER_PORT="<your_server_port>"

# Function to generate a new client
generate_client() {
    CLIENT_NAME=$1
    CLIENT_DIR="${CLIENTS_DIR}/${CLIENT_NAME}"

    if [ -d "${CLIENT_DIR}" ]; then
        echo "Client with the name ${CLIENT_NAME} already exists."
        exit 1
    fi

    mkdir -p "${CLIENT_DIR}"

    # Generate keys for the client
    CLIENT_PRIVATE_KEY=$(wg genkey)
    CLIENT_PUBLIC_KEY=$(echo "${CLIENT_PRIVATE_KEY}" | wg pubkey)
    CLIENT_PRESHARED_KEY=$(wg genpsk)

    # Save keys to files
    echo "${CLIENT_PRIVATE_KEY}" > "${CLIENT_DIR}/private.key"
    echo "${CLIENT_PUBLIC_KEY}" > "${CLIENT_DIR}/public.key"
    echo "${CLIENT_PRESHARED_KEY}" > "${CLIENT_DIR}/preshared.key"

    # IP address for the new client
    CLIENT_IP4="10.66.66.$((2 + $(ls -1q ${CLIENTS_DIR} | wc -l)))/24"
    CLIENT_IP6="fd42:42:42::$(($(ls -1q ${CLIENTS_DIR} | wc -l) + 2))/64"

    # Create the client's configuration file
    cat << EOF > "${CLIENT_DIR}/wg0-client-${CLIENT_NAME}.conf"
[Interface]
PrivateKey = ${CLIENT_PRIVATE_KEY}
Address = ${CLIENT_IP4},${CLIENT_IP6}
DNS = 8.8.8.8,8.8.4.4

[Peer]
PublicKey = ${SERVER_PUBLIC_KEY}
Endpoint = ${SERVER_IP}:${SERVER_PORT}
PresharedKey = ${CLIENT_PRESHARED_KEY}
AllowedIPs = 0.0.0.0/0,::/0
EOF

    echo "Configuration for client ${CLIENT_NAME} created."
    echo "Client configuration file: ${CLIENT_DIR}/wg0-client-${CLIENT_NAME}.conf"
    echo "Client public key: ${CLIENT_PUBLIC_KEY}"
    echo "Client private key: ${CLIENT_PRIVATE_KEY}"
    echo "Client preshared key: ${CLIENT_PRESHARED_KEY}"
}

# Check if client name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <client_name>"
    exit 1
fi

generate_client "$1"
