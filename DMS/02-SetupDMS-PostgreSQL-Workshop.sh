#!/bin/bash

echo "[DMS Wrapper] Creating source endpoint..."
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/create-endpoint.html
export SOURCE_ENDPOINT_URL=$(aws ec2 describe-instances \
  --filters 'Name=tag:Name,Values=Source-Java-DBServer'  \
  --region us-west-2 \
  --query 'Reservations[*].Instances[*].[PrivateDnsName]' --output text)

export SOURCE_ENDPOINT_ARN=$(aws dms create-endpoint \
    --endpoint-type source \
    --engine-name postgres \
    --database-name unicorn \
    --endpoint-identifier source-PostgreSQL-endpoint \
    --username unicorn \
    --password awsrocks2021 \
    --server-name $SOURCE_ENDPOINT_URL \
    --region us-west-2 \
    --port 5432 | jq -r .[].EndpointArn)

echo "[DMS Wrapper] Creating target endpoint..."
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/describe-db-instances.html
export TARGET_ENDPOINT_URL=$(aws rds describe-db-instances \
    --query 'DBInstances[*].[Endpoint.Address]' \
    --filters Name=db-instance-id,Values="unicorn" --region us-west-2 --output text)

export TARGET_ENDPOINT_ARN=$(aws dms create-endpoint \
    --endpoint-type target \
    --engine-name postgres \
    --database-name unicorn \
    --endpoint-identifier unicorn \
    --username unicorn \
    --password awsrocks2021 \
    --server-name $TARGET_ENDPOINT_URL \
    --region us-west-2 \
    --my-sql-settings '{ "CleanSourceMetadataOnMismatch": true, "ParallelLoadThreads": 1 }' \
    --port 5432 | jq -r .[].EndpointArn)

echo "[DMS Wrapper] Creating replication instance..."
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/create-replication-instance.html
export REPLICATION_INSTANCE_ARN=$(aws dms create-replication-instance \
    --replication-instance-identifier unicorn2 \
    --replication-instance-class dms.t3.medium \
    --engine-version 3.5.1 \
    --region us-west-2 \
    --allocated-storage 20 | jq -r .[].ReplicationInstanceArn)
    
echo "[DMS Wrapper] Creating replication instance...waiting..."
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/wait/replication-instance-available.html
aws dms wait --region us-west-2 replication-instance-available

echo "[DMS Wrapper] Creating replication task..."
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/create-replication-task.html
export REPLICATION_TASK_ARN=$(aws dms create-replication-task \
    --replication-task-identifier replication-postgre \
    --source-endpoint-arn $SOURCE_ENDPOINT_ARN \
    --target-endpoint-arn $TARGET_ENDPOINT_ARN \
    --replication-instance-arn $REPLICATION_INSTANCE_ARN \
    --migration-type full-load-and-cdc \
    --region us-west-2 \
    --table-mappings file://table-mappings-postgresql.json  | jq -r .[].ReplicationTaskArn)
aws dms wait --region us-west-2 replication-task-ready

echo "[DMS Wrapper] Testing source-replication instance connections..."
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/test-connection.html
aws dms test-connection \
    --replication-instance-arn $REPLICATION_INSTANCE_ARN \
    --region us-west-2 \
    --endpoint-arn $SOURCE_ENDPOINT_ARN >> /dev/null
aws dms wait --region us-west-2 test-connection-succeeds
echo "[DMS Wrapper] Testing target-replication instance connections..."
aws dms test-connection \
    --replication-instance-arn $REPLICATION_INSTANCE_ARN \
    --region us-west-2 \
    --endpoint-arn $TARGET_ENDPOINT_ARN >> /dev/null
aws dms wait --region us-west-2 test-connection-succeeds

echo "[DMS Wrapper] Starting replication task..."
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/start-replication-task.html
aws dms start-replication-task \
    --replication-task-arn $REPLICATION_TASK_ARN \
    --region us-west-2 \
    --start-replication-task-type start-replication >> /dev/null
