#!/bin/bash
sudo apt-get update && sudo apt-get install -y mumble-server


sudo systemctl stop mumble-server || true
sudo killall mumble-server || true


chmod 777 .

echo "Starting Billboard Node..."

mumble-server -fg -ini murmur.ini
