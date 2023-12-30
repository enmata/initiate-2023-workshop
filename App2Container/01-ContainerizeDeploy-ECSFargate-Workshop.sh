#!/bin/bash

AWS_DEFAULT_REGION=us-west-2
AWS_REGION=us-west-2

echo "[App2Container Wrapper] Creating inventory and locating your application..."
export APP_ID=$(app2container inventory | jq -r --stream -n 'input[0][0]')
echo "The app ID is $APP_ID"

echo "[App2Container Wrapper] Analyzing the your application..."
app2container analyze --application-id $APP_ID

echo "[App2Container Wrapper] Containerizing your application..."
app2container containerize --application-id $APP_ID

echo "[App2Container Wrapper] Setting up deployment stack and deploying it..."
export TARGETVPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=TargetVPC" --region us-west-2 --query Vpcs[*].VpcId --output text)
cp /root/app2container/$APP_ID/deployment.json /root/app2container/$APP_ID/deployment.json.tmp
jq --arg TARGETVPC_ID $TARGETVPC_ID '.ecsParameters.reuseResources.vpcId = $TARGETVPC_ID' /root/app2container/$APP_ID/deployment.json.tmp > /root/app2container/$APP_ID/deployment.json
app2container generate app-deployment --application-id $APP_ID

echo "[App2Container Wrapper] Deploying the application..."
# export SUBNET_ID1=$(aws ec2 describe-subnets --region us-west-2 --filters "Name=cidr-block,Values=10.1.0.0/24" --query "Subnets[*].SubnetId" --output text)
# export SUBNET_ID2=$(aws ec2 describe-subnets --region us-west-2 --filters "Name=cidr-block,Values=10.1.1.0/24" --query "Subnets[*].SubnetId" --output text)
# aws cloudformation deploy --template-file /root/app2container/$APP_ID/EcsDeployment/ecs-master.yml --region us-west-2 --parameter-overrides PublicSubnets=$SUBNET_ID1,$SUBNET_ID2 --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --stack-name a2c-$APP_ID-ECS
aws cloudformation deploy --template-file /root/app2container/$APP_ID/EcsDeployment/ecs-master.yml --region us-west-2 --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --stack-name a2c-$APP_ID-ECS
aws cloudformation wait stack-create-complete --region us-west-2 --stack-name a2c-$APP_ID-ECS

echo "[App2Container Wrapper] Setting up pipeline for your application..."
# https://docs.aws.amazon.com/cli/latest/reference/cloudformation/describe-stacks.html
cp /root/app2container/$APP_ID/pipeline.json /root/app2container/$APP_ID/pipeline.json.tmp
export ECS_SERVICE_ID=$(aws cloudformation describe-stacks --stack-name a2c-$APP_ID-ECS --region us-west-2 --query 'Stacks[*].Outputs[?OutputKey==`ECSService`].OutputValue' --output text)
export ECS_CLUSTER_ID=$(aws cloudformation describe-stacks --stack-name a2c-$APP_ID-ECS --region us-west-2 --query 'Stacks[*].Outputs[?OutputKey==`ClusterId`].OutputValue' --output text)
jq --arg ECS_SERVICE_ID $ECS_SERVICE_ID --arg ECS_CLUSTER_ID $ECS_CLUSTER_ID '.releaseInfo.ECS.prod.enabled = true | .releaseInfo.ECS.prod.serviceName = $ECS_SERVICE_ID | .releaseInfo.ECS.prod.clusterName = $ECS_CLUSTER_ID' /root/app2container/$APP_ID/pipeline.json.tmp > /root/app2container/$APP_ID/pipeline.json
app2container generate pipeline --application-id $APP_ID

echo "[App2Container Wrapper] Deploying the pipeline..."
aws cloudformation deploy --template-file /root/app2container/$APP_ID/Artifacts/Pipeline/CodePipeline/ecs-pipeline-master.yml --region us-west-2 --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --stack-name a2c-$APP_ID-ecs-pipeline-stack

