#!/bin/bash

echo "[Hugo Wrapper] Installing dependencies..."
sudo apt-get update >> /dev/null
sudo apt-get install nginx -y >> /dev/null
wget -q https://github.com/gohugoio/hugo/releases/download/v0.119.0/hugo_extended_0.119.0_linux-amd64.tar.gz
tar xf hugo_extended_0.119.0_linux-amd64.tar.gz
chmod +x hugo
sudo mv ./hugo /usr/bin
hugo version

echo "[Hugo Wrapper] Downloading hugo example template..."
git clone https://github.com/themefisher/airspace-hugo

echo "[Hugo Wrapper] Generating static webside from example template..."
cd airspace-hugo/exampleSite
hugo --themesDir ../.. --baseURL /

echo "[Hugo Wrapper] MIgrating webside to nginx webserver folders..."
sudo mv public/* /var/www/html/
sudo chmod 755 -R /var/www/html/

echo "[Hugo Wrapper] Restarting services..."
sudo service nginx restart
