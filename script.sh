#!/bin/bash

# Update packages
apt-get update -y

# Install AWS CLI
apt-get install -y awscli

# Create script directory
mkdir -p /usr/local/bin/

# Create disk publishing script
cat << 'EOT' > /usr/local/bin/publish_disk_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
ENVIRONMENT="${environment}"
HOSTNAME=$(hostname)

REGION="${region}"

DISK_USED=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

aws cloudwatch put-metric-data \
  --region "$REGION" \
  --namespace "$NAMESPACE" \
  --metric-name "DiskUsageRootPercent" \
  --value "$DISK_USED" \
  --unit Percent \
  --dimensions Environment=$ENVIRONMENT,Host=$HOSTNAME

EOT

chmod +x /usr/local/bin/publish_disk_metrics.sh

# Add cron job to run every 1 minute
(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_disk_metrics.sh") | crontab -

# Install and configure CloudWatch agent
apt-get update -y
apt-get install -y amazon-cloudwatch-agent

cat << 'CONFIG' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/ubuntu/logs",
            "log_stream_name": "{instance_id}-syslog"
          },
          {
            "file_path": "/var/log/auth.log",
            "log_group_name": "/ubuntu/logs",
            "log_stream_name": "{instance_id}-auth"
          }
        ]
      }
    }
  }
}
CONFIG

systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent
