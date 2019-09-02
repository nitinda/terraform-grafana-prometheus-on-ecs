#!/bin/bash
echo ECS_CLUSTER=${ECS_CLUSTER_NAME} >> /etc/ecs/ecs.config
echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config
echo ECS_LOGLEVEL=debug >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config

# Install SSM Agent
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm ec2-instance-connect nfs-utils bind-utils

# Updating the ECS agent
# yum update -y ecs-init

# Use this command if you only want to support EBS Only
docker plugin install --alias rexray-aws-ebs --grant-all-permissions rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${EBS_REGION} DOCKER_LEGACY=false EBS_MAXRETRIES=10 LINUX_VOLUME_FILEMODE=0777

#verify that the agent is running
curl -s http://localhost:51678/v1/metadata