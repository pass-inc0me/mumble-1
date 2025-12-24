#!/bin/bash

# --- 1. INSTALLATION SECTION ---
echo "Installing Mumble, Bore, and OpenSSL..."
sudo apt-get update
sudo apt-get install -y mumble-server wget openssl

# Download and install Bore (the tunnel tool)
wget https://github.com/ekzhang/bore/releases/download/v0.6.0/bore-v0.6.0-x86_64-unknown-linux-musl.tar.gz
tar -xf bore-v0.6.0-x86_64-unknown-linux-musl.tar.gz
sudo mv bore /usr/local/bin/
rm bore-v0.6.0-x86_64-unknown-linux-musl.tar.gz

# --- 2. IDENTITY SECTION ---
# Generate a real, matching SSL pair so Mumble doesn't crash
openssl req -x509 -newkey rsa:2048 -nodes -keyout server.key -out server.crt -subj "/CN=MumbleBillboard" -days 365

# --- 3. CONFIGURATION SECTION ---
cat <<EOF > mumble.ini
database=mumble.sqlite
icesecretwrite=
logfile=mumble.log
sslCert=server.crt
sslKey=server.key
welcometext="<br />Welcome to <b>GitHub Billboard</b>"
port=64738
users=100
# Un-comment the lines below if you want it on the public list:
# registerName=GitHub Billboard
# registerUrl=https://github.com
EOF

# --- 4. EXECUTION SECTION ---
echo "Fixing port conflicts..."
# Stop the default background service that 'apt' starts automatically
sudo systemctl stop mumble-server || true
# Kill any lingering mumble processes just in case
sudo pkill -9 mumble-server || true

echo "Starting Your Custom Mumble Server..."
# Run in background
mumble-server -ini mumble.ini &

# Give it a moment to generate the SuperUser password in the log
sleep 5

echo "--------------------------------------------------"
echo "SERVER BOOTED SUCCESSFULLY!"
echo "Check the logs above for your 'SuperUser' password."
echo "The line looks like: 1 => Password for 'SuperUser' set to 'XXXX'"
echo "--------------------------------------------------"

# Start the tunnel. This will stay open and keep the Action running.
echo "Opening Tunnel to the Internet..."
bore local 64738 --to bore.pub
