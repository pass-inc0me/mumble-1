#!/bin/bash
# 1. Install Mumble
sudo apt-get update && sudo apt-get install -y mumble-server

# 2. Install Ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt-get update && sudo apt-get install ngrok

# 3. Authenticate (REPLACE 'YOUR_TOKEN' WITH YOUR REAL TOKEN)
ngrok config add-authtoken YOUR_TOKEN_HERE

# 4. Start the tunnel in the background
# This creates a public TCP address for Mumble
ngrok tcp 64738 --log=stdout > ngrok.log &
sleep 5

# 5. Clean up background Mumble processes
sudo systemctl stop mumble-server || true
sudo killall mumble-server || true

# 6. Start your Billboard
echo "Billboard is now tunneling through ngrok..."
mumble-server -fg -ini murmur.ini
