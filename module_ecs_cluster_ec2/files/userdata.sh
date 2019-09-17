#!/bin/bash
echo ECS_CLUSTER=${ECS_CLUSTER_NAME} >> /etc/ecs/ecs.config
echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config
echo ECS_LOGLEVEL=debug >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config

# Install SSM Agent
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm ec2-instance-connect nfs-utils bind-utils

# Use this command if you only want to support EBS Only
docker plugin install --alias rexray-aws-ebs --grant-all-permissions rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${EBS_REGION} DOCKER_LEGACY=false EBS_MAXRETRIES=10 LINUX_VOLUME_FILEMODE=0777

# Use this command if you only want to support EBS (https://github.com/docker/for-aws/issues/157)
# docker plugin install --alias cloudstor-ebs:aws --grant-all-permissions docker4x/cloudstor:18.03.0-ce-aws2 CLOUD_PLATFORM=AWS AWS_REGION=${EBS_REGION} EFS_SUPPORTED=0 DEBUG=1


#verify that the agent is running
curl -s http://localhost:51678/v1/metadata


# updates
yum -y --security update
yum -y install jq nvme-cli
easy_install pip
pip install --upgrade awscli


# Spot
mkdir /lib/systemd/system/spot-instance-termination-notice-handler

# Create a Unit file to define a systemd service:
cat <<EOF > /lib/systemd/system/spot-instance-termination-notice-handler/spot-instance-termination-notice-handler.service
[Unit]
Description=Start spot instance termination handler monitoring script

[Service]
Type=simple
ExecStart=/bin/bash /usr/local/bin/spot-instance-termination-notice-handler.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target

EOF

cp /lib/systemd/system/spot-instance-termination-notice-handler/spot-instance-termination-notice-handler.service /etc/systemd/system/spot-instance-termination-notice-handler.service
chmod 644 /etc/systemd/system/spot-instance-termination-notice-handler.service

cat <<EOF > /usr/local/bin/spot-instance-termination-notice-handler.sh
#!/bin/bash
while sleep 5; do
if [ -z \$(curl -Isf http://169.254.169.254/latest/meta-data/spot/termination-time)];
then
    /bin/false
else
    logger "[spot-instance-termination-notice-handler.sh]: spot instance termination notice detected"
    STATUS=DRAINING
    ECS_CLUSTER=\$(curl -s http://localhost:51678/v1/metadata | jq .Cluster | tr -d \")
    CONTAINER_INSTANCE=\$(curl -s http://localhost:51678/v1/metadata | jq .ContainerInstanceArn| tr -d \")
    AWSCLI=\$(which aws)
    
    logger "[spot-instance-termination-notice-handler.sh]: putting instance in state\$STATUS"
    logger "[spot-instance-termination-notice-handler.sh]: running: /usr/local/bin/aws ecs update-container-instances-state --cluster \$ECS_CLUSTER --container-instances \$CONTAINER_INSTANCE --status \$STATUS"
    
    \$AWSCLI ecs update-container-instances-state --cluster \$ECS_CLUSTER --container-instances \$CONTAINER_INSTANCE --status \$STATUS --region \$EBS_REGION
    logger "[spot-instance-termination-notice-handler.sh]: putting myself to sleep..."
    sleep 120
fi
done
EOF
chmod 755 /usr/local/bin/spot-instance-termination-notice-handler.sh


systemctl start spot-instance-termination-notice-handler
systemctl enable spot-instance-termination-notice-handler