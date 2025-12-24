#!/bin/bash

# 1. Install Mumble and dependencies
sudo apt-get update
sudo apt-get install -y mumble-server wget jq

# 2. Install Bore (The firewall bypass)
wget https://github.com/ekzhang/bore/releases/download/v0.5.0/bore-v0.5.0-x86_64-unknown-linux-musl.tar.gz
tar -xf bore-v0.5.0-x86_64-unknown-linux-musl.tar.gz
chmod +x bore

# 3. Start Bore in the background and capture the port it gives us
./bore local 64738 --to bore.pub > bore.log 2>&1 &
sleep 5

# Extract the remote port from the log
BORE_PORT=$(grep -oP 'listening at bore.pub:\K\d+' bore.log)

echo "--------------------------------------------------"
echo "FIREWALL BYPASS ACTIVE: bore.pub:$BORE_PORT"
echo "--------------------------------------------------"

# 4. Dynamically update your murmur.ini with the new public port
sed -i "s/^port=.*/port=$BORE_PORT/" murmur.ini
echo "registerHostname=bore.pub" >> murmur.ini

# 5. Start Mumble
echo "Starting Billboard Node on Master List..."
mumble-server -fg -ini murmur.ini
