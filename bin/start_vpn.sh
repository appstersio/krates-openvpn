#!/bin/bash

# Wrapper script to enable some waiting for Weave network to become active
# If VPN is activated before Weave, Weave network doesn't work :(

echo "Waiting for ethwe to become active"

while ! [ -n "$(ip addr show | grep ethwe:)" ]; do
    sleep 1
    printf "."
done
echo "\nWeave network active, proceeding with VPN startup"
# Setup NAT for ethwe
iptables -t nat -A POSTROUTING -o ethwe -j MASQUERADE

OVPN_CA_PASSPHRASE=openssl rand -base64 32

# Generate configs
ovpn_genconfig -u $OVPN_SERVER_URL

# Initialize PKI stuff
ovpn_initpki nopass

# Create client certs and config
easyrsa build-client-full QTCS_VPN_CLIENT nopass

# Start VPN normally
ovpn_run