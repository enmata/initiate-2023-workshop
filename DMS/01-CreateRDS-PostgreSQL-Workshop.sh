#!/bin/bash

echo "[RDS Wrapper] Getting Subnet IDs..."
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-subnets.html
export SUBNET_ID1=$(aws ec2 describe-subnets --region us-west-2 --filters "Name=cidr-block,Values=10.1.201.0/24" --query "Subnets[*].SubnetId" --output text)
export SUBNET_ID2=$(aws ec2 describe-subnets --region us-west-2 --filters "Name=cidr-block,Values=10.1.101.0/24" --query "Subnets[*].SubnetId" --output text)

echo "[RDS Wrapper] Creating subnet group..."
# https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-subnet-group.html
aws rds create-db-subnet-group      \
    --db-subnet-group-name database-subnet-group \
    --db-subnet-group-description "Subnets where RDS will be deployed" \
    --region us-west-2 \
    --subnet-ids "[ \"$SUBNET_ID1\", \"$SUBNET_ID2\" ]" >> /dev/null

# https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-parameter-group.html
aws rds create-db-parameter-group \
    --db-parameter-group-name unicorn-db-parameter-group \
    --db-parameter-group-family postgres11 \
    --region us-west-2 \
    --description "App2Container target parameter-group" >> /dev/null

echo "[RDS Wrapper] Creating parameter group..."
# https://docs.aws.amazon.com/cli/latest/reference/rds/modify-db-parameter-group.html
aws rds modify-db-parameter-group \
    --db-parameter-group-name unicorn-db-parameter-group \
    --region us-west-2 \
    --parameters "ParameterName='session_replication_role',ParameterValue=replica,ApplyMethod=immediate" >> /dev/null

echo "[RDS Wrapper] Creating RDS instance..."
# https://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
aws rds create-db-instance \
    --db-instance-identifier unicorn \
    --db-instance-class db.t3.micro \
    --engine postgres \
    --engine-version 11.17 \
    --master-username unicorn \
    --master-user-password awsrocks2021 \
    --db-name unicorn \
    --db-parameter-group-name unicorn-db-parameter-group \
    --db-subnet-group-name database-subnet-group \
    --region us-west-2 \
    --allocated-storage 20 >> /dev/null

echo "[RDS Wrapper] Creating RDS instance...waiting to be ready..."
aws rds wait db-instance-available \
    --db-instance-identifier unicorn >> /dev/null
