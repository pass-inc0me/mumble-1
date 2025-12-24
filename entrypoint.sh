#!/bin/bash
sudo apt-get update
sudo apt-get install -y mumble-server wget curl jq
wget https://github.com/ekzhang/bore/releases/download/v0.5.1/bore-v0.5.1-x86_64-unknown-linux-musl.tar.gz
tar -xf bore-v0.5.1-x86_64-unknown-linux-musl.tar.gz
sudo mv bore /usr/local/bin/
sudo pkill -9 mumble-server || true
mumble-server -ini mumble.ini &
bore local 64738 --to bore.pub
