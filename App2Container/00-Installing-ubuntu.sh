#!/bin/bash

echo "[App2Container Wrapper] Installing dependencies..."
apt-get update >> /dev/null
apt-get install jq curl -y >> /dev/null
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-get update >> /dev/null
apt-get install docker-ce -y >> /dev/null
service docker start
aws configure set region us-west-2

echo "[App2Container Wrapper] Creating bucket..."
aws s3api create-bucket --bucket app2container-workshop-20230222 --create-bucket-configuration LocationConstraint=us-west-2

echo "[App2Container Wrapper] Installing App2Container..."
curl -o AWSApp2Container-installer-linux.tar.gz https://app2container-release-us-east-1.s3.us-east-1.amazonaws.com/latest/linux/AWSApp2Container-installer-linux.tar.gz
tar xvf AWSApp2Container-installer-linux.tar.gz
yes | ./install.sh

echo "[App2Container Wrapper] Wrapping up installer..."
rm -rf AWSApp2Container-installer-linux.tar.gz

echo "[App2Container Wrapper] Initializing App2Container..."
app2container init
