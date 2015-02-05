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

cp /usr/local/share/easy-rsa/easyrsa3/openssl-1.0.cnf /etc/openvpn

# Generate configs, can be pretty safely overwritten
ovpn_genconfig -u $OVPN_SERVER_URL

# Initialize PKI stuff, need to guard these as the EasyRSA 
# would override the existing config
if [ ! -f "$EASYRSA_PKI/private/ca.key" ]; then
    ovpn_initpki nopass
else
    echo "PKI already initialized, using old configuration"
fi

# Create client certs and config
if [ ! -f "$EASYRSA_PKI/private/QTCS_VPN_CLIENT.key" ]; then
    easyrsa build-client-full QTCS_VPN_CLIENT nopass
else
    echo "Client certificate already initialized, using old configuration"
fi

# Start VPN normally
ovpn_run