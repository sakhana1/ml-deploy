#!/bin/bash
set -e
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
ACCOUNT=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | grep accountId | cut -d'"' -f4)
IMAGE=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com/ml-model-app:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com
docker pull $IMAGE
docker run -d --name ml-app --restart unless-stopped -p 80:8000 $IMAGE
