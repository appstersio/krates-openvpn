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

# Start VPN normally
ovpn_run