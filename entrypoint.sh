#!/bin/bash

# 1. INSTALLATION
echo "Installing Mumble and Bore..."
sudo apt-get update && sudo apt-get install -y mumble-server wget openssl
wget https://github.com/ekzhang/bore/releases/download/v0.6.0/bore-v0.6.0-x86_64-unknown-linux-musl.tar.gz
tar -xf bore-v0.6.0-x86_64-unknown-linux-musl.tar.gz
sudo mv bore /usr/local/bin/

# 2. GENERATE VALID MATCHING KEYS
# This creates a real, working SSL pair so Mumble doesn't crash
openssl req -x509 -newkey rsa:2048 -nodes -keyout server.key -out server.crt -subj "/CN=MumbleBillboard" -days 365

# 3. CONFIGURATION
cat <<EOF > mumble.ini
database=mumble.sqlite
icesecretwrite=
logfile=mumble.log
sslCert=server.crt
sslKey=server.key
welcometext="<br />Welcome to <b>GitHub Billboard</b>"
port=64738
users=100
# We will leave registration off for just a second to ensure it boots
EOF

# 4. EXECUTION
echo "Starting Mumble Server..."
# We use -fg here so we can see the logs if it fails again
mumble-server -ini mumble.ini -fg &

sleep 3

echo "--------------------------------------------------"
echo "SERVER IS LIVE!"
echo "Connect to: bore.pub:19132 (or whatever port shows below)"
echo "--------------------------------------------------"

bore local 64738 --to bore.pub
