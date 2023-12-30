#!/bin/bash

echo "[AMS Wrapper] Setting up environment vars..."
export AWS_DEFAULT_REGION=us-west-2
export AWS_REGION=us-west-2
export AWS_ACCESS_KEY_ID="XXX"
export AWS_SECRET_ACCESS_KEY="YYY"
export AWS_SESSION_TOKEN="ZZZ"

echo "[AMS Wrapper] Installing dependencies..."
sudo apt-get update > /dev/null
sudo apt-get install python3 python-is-python3 -y > /dev/null
sudo apt-get install make openssl wget curl gcc build-essential -y > /dev/null

# echo "[AMS Wrapper] Initalizing dependencies..."
# # https://docs.aws.amazon.com/mgn/latest/ug/mgn-initialize-api.html
# aws mgn initialize-service
# aws mgn create-replication-configuration-template
# aws mgn create-launch-configuration-template

echo "[AMS Wrapper] Installing AMS Agent..."
# https://docs.aws.amazon.com/mgn/latest/ug/linux-agent.html
wget -q -O ./aws-replication-installer-init.py https://aws-application-migration-service-us-west-2.s3.amazonaws.com/latest/linux/aws-replication-installer-init.py
sudo ./aws-replication-installer-init.py --no-prompt \
    --region $AWS_REGION  \
    --aws-access-key-id $AWS_ACCESS_KEY_ID  \
    --aws-secret-access-key $AWS_SECRET_ACCESS_KEY  \
    --aws-session-token $AWS_SESSION_TOKEN

# Status
# https://docs.aws.amazon.com/mgn/latest/ug/Troubleshooting-Agent-Issues.html#Error-Installation-Failed
systemctl status aws-replication.target
tail /var/lib/aws-replication-agent/agent.log.0
