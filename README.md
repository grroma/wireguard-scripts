# WireGuard Scripts

This repository contains scripts to manage WireGuard VPN configurations. It includes a script to generate client configurations with unique keys and IP addresses.

## Prerequisites

- WireGuard installed on your server
- Bash shell

## Script Overview

### generate_client.sh

This script generates a new WireGuard client configuration, including the generation of private, public, and preshared keys. It creates a unique configuration file for each client.

### Usage

To use the `generate_client.sh` script, follow these steps:

1. Clone this repository to your server.
2. Navigate to the directory containing the scripts.
3. Make sure the script is executable:
    ```sh
    chmod +x generate_client.sh
    ```
4. Run the script with the desired client name:
    ```sh
    ./generate_client.sh <client_name>
    ```

### Example

```sh
./generate_client.sh myclient
```