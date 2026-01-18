#!/bin/bash

# Redirect output to log file for debugging
exec > /var/log/user-data.log 2>&1
echo "Starting user-data script at $(date)"

# Update packages
echo "Updating packages..."
apt-get update -y

# Install AWS CLI
echo "Installing AWS CLI..."
apt-get install -y awscli

# Create script directory
echo "Creating /usr/local/bin/..."
mkdir -p /usr/local/bin/

echo "Directory created: $(ls -ld /usr/local/bin/)"

# Create disk publishing script
echo "Creating disk metrics script..."
cat << 'EOT' > /usr/local/bin/publish_disk_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
ENVIRONMENT="${environment}"
HOSTNAME=$(hostname)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)


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

(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_disk_metrics.sh") | crontab -

cat << 'EOT' > /usr/local/bin/publish_CPU_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
HOSTNAME=$(hostname)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION="${region}"
ENVIRONMENT="${environment}"

# CPU usage (percentage)
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}')
# Some environments report differently; fallback using mpstat if available
if [ -z "$CPU_IDLE" ]; then
  if command -v mpstat >/dev/null 2>&1; then
    CPU_IDLE=$(mpstat 1 1 | awk '/Average/ {print 100 - $NF}')
  else
    CPU_IDLE=0
  fi
fi
CPU_USED=$(awk "BEGIN {printf \"%.2f\", 100 - $CPU_IDLE}")

aws cloudwatch put-metric-data \
  --region "$REGION" \
  --namespace "$NAMESPACE" \
  --metric-name "customCPUUtils" \
  --value "$CPU_USED" \
  --unit Percent \
  --dimensions Environment=$ENVIRONMENT,Host=$HOSTNAME



EOT

chmod +x /usr/local/bin/publish_CPU_metrics.sh

# Add cron job to run RAM metrics script every 1 minute
(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_CPU_metrics.sh") | crontab -

cat << 'EOT' > /usr/local/bin/publish_RAM_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
HOSTNAME=$(hostname)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION="${region}"
ENVIRONMENT="${environment}"

# Memory usage (percentage)
RAM_USED=$(free | awk '/Mem/ {printf "%.2f", $3/$2 * 100}')
aws cloudwatch put-metric-data \
  --region "$REGION" \
  --namespace "$NAMESPACE" \
  --metric-name "RAMUsed" \
  --value "$RAM_USED" \
  --unit Percent \
  --dimensions Environment=$ENVIRONMENT,Host=$HOSTNAME
EOT
chmod +x /usr/local/bin/publish_RAM_metrics.sh

# Add cron job to run system metrics script every 1 minute
(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_RAM_metrics.sh") | crontab -

cat << 'EOT' > /usr/local/bin/publish_Latency_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
HOSTNAME=$(hostname)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION="${region}"
ENVIRONMENT="${environment}"

LATENCY_VAL=$(ping -c 1 8.8.8.8 | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)

aws cloudwatch put-metric-data \
  --region "$REGION" \
  --namespace "$NAMESPACE" \
  --metric-name "NetworkLatency" \
  --value "$LATENCY_VAL" \
  --unit Milliseconds \
  --dimensions Environment=$ENVIRONMENT,Host=$HOSTNAME

EOT
chmod +x /usr/local/bin/publish_Latency_metrics.sh

# Add cron job to run system metrics script every 1 minute
(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_Latency_metrics.sh") | crontab -

echo "Installing CloudWatch agent..."
wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O /tmp/amazon-cloudwatch-agent.deb
dpkg -i /tmp/amazon-cloudwatch-agent.deb
apt-get install -f -y 

cat << 'CONFIG' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/ubuntu/logs",
            "log_stream_name": "{INSTANCE_ID}-syslog"
          },
          {
            "file_path": "/var/log/auth.log",
            "log_group_name": "/ubuntu/logs",
            "log_stream_name": "{INSTANCE_ID}-auth"
          }
        ]
      }
    }
  }
}
CONFIG

systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent
