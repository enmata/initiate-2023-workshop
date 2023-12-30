#!/bin/bash

echo "[App2Container Wrapper] Installing dependencies..."
sudo yum update  >> /dev/null
sudo yum install jq curl -y  >> /dev/null
sudo amazon-linux-extras install docker  >> /dev/null
sudo service docker start
sudo usermod -a -G docker ec2-user
aws configure set region us-west-2

echo "[App2Container Wrapper] Creating bucket..."
aws s3api create-bucket --bucket app2container-workshop-20230222 --create-bucket-configuration LocationConstraint=us-west-2

echo "[App2Container Wrapper] Installing App2Container..."
curl -o AWSApp2Container-installer-linux.tar.gz https://app2container-release-us-east-1.s3.us-east-1.amazonaws.com/latest/linux/AWSApp2Container-installer-linux.tar.gz
tar xvf AWSApp2Container-installer-linux.tar.gz
yes | sudo ./install.sh

echo "[App2Container Wrapper] Wrapping up installer..."
rm -rf AWSApp2Container-installer-linux.tar.gz

echo "[App2Container Wrapper] Initializing App2Container..."
sudo app2container init
