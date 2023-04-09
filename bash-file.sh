#!/bin/bash

aws configure set aws_access_key_id $YOUR_ACCESS_KEY_ID && aws configure set aws_secret_access_key $YOUR_SECRET_ACCESS_KEY && aws configure set default.region $YOUR_AWS_DEFAULT_REGION && aws configure set default.output json

microk8s kubectl create secret docker-registry rrrrr --docker-server=REGISTRY_ID.dkr.ecr.ap-south-1.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password) --docker-email=<optional>

touch script.sh && echo 'microk8s kubectl patch secret rrrrr  --patch="{\"data\": { \"docker-password\": \"$(aws ecr get-login-password|base64 -w0)\" }}"  ' > script.sh

crontab <<EOF
0 */12 * * * bash script.sh
EOF
