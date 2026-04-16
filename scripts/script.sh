#!/bin/bash

# Redirect output to log file for debugging
exec > /var/log/user-data.log 2>&1
echo "Starting user-data script at $(date)"
LOG_GROUP_NAME="/ubuntu/logs"

# Update packages
echo "Updating packages..."
apt-get update -y

# Install AWS CLI
echo "Installing AWS CLI..."
sudo apt remove awscli -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
rm awscliv2.zip

# Create script directory
echo "Creating /usr/local/bin/..."
mkdir -p /usr/local/bin/

echo "Directory created: $(ls -ld /usr/local/bin/)"

# Create disk publishing script
echo "Creating disk metrics script..."
cat << 'EOT' > /usr/local/bin/publish_disk_metrics.sh
#!/bin/bash
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
NAMESPACE="Custom/System"
ENVIRONMENT="${environment}"
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
REGION="${region}"

DISK_USED=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

aws cloudwatch put-metric-data \
  --region "$REGION" \
  --namespace "$NAMESPACE" \
  --metric-name "DiskUsageRootPercent" \
  --value "$DISK_USED" \
  --unit Percent \
  --dimensions InstanceId=$INSTANCE_ID

EOT

chmod +x /usr/local/bin/publish_disk_metrics.sh

cat << 'EOT' > /usr/local/bin/publish_CPU_metrics.sh
#!/bin/bash
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
NAMESPACE="Custom/System"
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
REGION="${region}"
ENVIRONMENT="${environment}"

# CPU usage (percentage)
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}')
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
  --dimensions InstanceId=$INSTANCE_ID

EOT

chmod +x /usr/local/bin/publish_CPU_metrics.sh

cat << 'EOT' > /usr/local/bin/publish_RAM_metrics.sh
#!/bin/bash
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
NAMESPACE="Custom/System"
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
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
  --dimensions InstanceId=$INSTANCE_ID

EOT

chmod +x /usr/local/bin/publish_RAM_metrics.sh

(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_RAM_metrics.sh") | crontab -

cat << 'EOT' > /usr/local/bin/publish_Latency_metrics.sh
#!/bin/bash
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
NAMESPACE="Custom/System"
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
REGION="${region}"
ENVIRONMENT="${environment}"

LATENCY_VAL=$(ping -c 1 8.8.8.8 | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1)

aws cloudwatch put-metric-data \
  --region "$REGION" \
  --namespace "$NAMESPACE" \
  --metric-name "NetworkLatency" \
  --value "$LATENCY_VAL" \
  --unit Milliseconds \
  --dimensions InstanceId=$INSTANCE_ID

EOT

chmod +x /usr/local/bin/publish_Latency_metrics.sh

echo "Installing CloudWatch agent..."
wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O /tmp/amazon-cloudwatch-agent.deb
dpkg -i /tmp/amazon-cloudwatch-agent.deb
apt-get install -f -y 

cat << CONFIG > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "$LOG_GROUP_NAME",
            "log_stream_name": "{instance_id}-syslog"
          },
          {
            "file_path": "/var/log/auth.log",
            "log_group_name": "$LOG_GROUP_NAME",
            "log_stream_name": "{instance_id}-auth"
          },
          {
            "file_path": "/var/log/application.log",
            "log_group_name": "$LOG_GROUP_NAME",
            "log_stream_name": "{instance_id}-application"
          },
          {
            "file_path": "/var/log/user-data.log",
            "log_group_name": "$LOG_GROUP_NAME",
            "log_stream_name": "{instance_id}-userdata"
          }
        ]
      }
    }
  }
}
CONFIG

systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent

# Install MySQL and dependencies
echo "Installing MySQL..."
export DEBIAN_FRONTEND=noninteractive
apt-get install -y mysql-server python3-pip
sudo pip3 install boto3 mysql-connector-python

# Start MySQL service
systemctl start mysql
systemctl enable mysql

# Wait for MySQL to be ready
sleep 5

# Create monitoring user with proper syntax
echo "Creating MySQL monitoring user..."
mysql -e "CREATE USER IF NOT EXISTS 'monitor_user'@'localhost' IDENTIFIED BY 'YourSecurePassword123';"
mysql -e "GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'monitor_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Test the connection
echo "Testing MySQL connection..."
mysql -u monitor_user -pYourSecurePassword123 -e "SHOW DATABASES;" || echo "MySQL connection test failed"

# Create Python script for MySQL metrics
cat << 'EOT' > /usr/local/bin/publish_mysql_metrics.py
#!/usr/bin/env python3
import boto3
import mysql.connector
from datetime import datetime
import os
import sys
import requests


try:
    token_url = "http://169.254.169.254/latest/api/token"
    token_headers = {"X-aws-ec2-metadata-token-ttl-seconds": "21600"}
    token_response = requests.put(token_url, headers=token_headers, timeout=5)
    token = token_response.text

    id_url = "http://169.254.169.254/latest/meta-data/instance-id"
    id_headers = {"X-aws-ec2-metadata-token": token}
    INSTANCE_ID = requests.get(id_url, headers=id_headers, timeout=5).text.strip()

    cloudwatch = boto3.client('cloudwatch', region_name='eu-west-2')


    
    db = mysql.connector.connect(
        host="localhost",
        user="monitor_user",
        password="YourSecurePassword123"
    )
    
    NAMESPACE = 'Custom/Application'

    
    def get_mysql_status(variable_name):
        cursor = db.cursor()
        cursor.execute(f"SHOW GLOBAL STATUS LIKE '{variable_name}'")
        result = cursor.fetchone()
        cursor.close()
        return int(result[1]) if result else 0
    
    def put_metric(metric_name, value, unit='Count'):
        cloudwatch.put_metric_data(
            Namespace=NAMESPACE,
            MetricData=[{
                'MetricName': metric_name,
                'Value': value,
                'Unit': unit,
                'Timestamp': datetime.utcnow(),
                'Dimensions': [
                    {'Name': 'InstanceId', 'Value': INSTANCE_ID},
                    {'Name': 'Database', 'Value': 'mysql'}
                ]
            }]
        )
    
    # Collect metrics
    active_connections = get_mysql_status('Threads_connected')
    slow_queries = get_mysql_status('Slow_queries')
    questions = get_mysql_status('Questions')
    aborted_connects = get_mysql_status('Aborted_connects')
    
    # Send metrics
    put_metric('MySQLActiveConnections', active_connections, 'Count')
    put_metric('MySQLSlowQueries', slow_queries, 'Count')
    put_metric('MySQLQueriesPerMinute', questions, 'Count')
    put_metric('MySQLAbortedConnections', aborted_connects, 'Count')
    
    # Calculate buffer pool hit rate
    buffer_reads = get_mysql_status('Innodb_buffer_pool_reads')
    buffer_read_requests = get_mysql_status('Innodb_buffer_pool_read_requests')
    
    if buffer_read_requests > 0:
        hit_rate = (1 - (buffer_reads / buffer_read_requests)) * 100
        put_metric('MySQLBufferPoolHitRate', hit_rate, 'Percent')
    
    print(f"MySQL metrics sent: {active_connections} connections, {slow_queries} slow queries")
    
    db.close()

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
EOT

chmod +x /usr/local/bin/publish_mysql_metrics.py

# Test the script once
echo "Testing MySQL metrics script..."
/usr/local/bin/publish_mysql_metrics.py

# Create a simple application log that writes metric values
cat << 'EOT' > /usr/local/bin/log_mysql_status.sh
#!/bin/bash
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
LOG_FILE="/var/log/application.log"

# Get MySQL connections
CONNECTIONS=$(mysql -u monitor_user -pYourSecurePassword123 -e "SHOW STATUS LIKE 'Threads_connected';" 2>/dev/null | awk 'NR==2 {print $2}')

# Log to file with timestamp
echo "$(date '+%Y-%m-%d %H:%M:%S') InstanceId=$INSTANCE_ID MySQLConnections=$CONNECTIONS" >> $LOG_FILE

# Check if connections are high and log ERROR
if [ "$CONNECTIONS" -gt 50 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR: High MySQL connections detected: $CONNECTIONS" >> $LOG_FILE
fi

# Check if connections are very high and log CRITICAL
if [ "$CONNECTIONS" -gt 100 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') CRITICAL: Very high MySQL connections: $CONNECTIONS" >> $LOG_FILE
fi

EOT

chmod +x /usr/local/bin/log_mysql_status.sh

# Add to cron to run every minute

cat << 'EOT' > /usr/local/bin/monitor_and_push.sh
#!/bin/bash
touch /tmp/app.log
LOG_FILE="/tmp/app.log"
# This matches your desired path
LOG_GROUP="/ubuntu/logs"
LOG_STREAM="TestAlertStream"

# Ensure the log group exists first
aws logs create-log-group --log-group-name "$LOG_GROUP" 2>/dev/null
# Ensure log stream exists
aws logs create-log-stream --log-group-name "$LOG_GROUP" --log-stream-name "$LOG_STREAM" 2>/dev/null

echo "Monitoring $LOG_FILE and pushing to $LOG_GROUP..."

(
  while true; do
    TIMESTAMP=$(date)
    if (( $RANDOM % 5 == 0 )); then
      echo "[$TIMESTAMP] CRITICAL: Test alert detected!" >> $LOG_FILE
    else
      echo "[$TIMESTAMP] INFO: Normal operation." >> $LOG_FILE
    fi
    sleep 2
  done
) &

tail -Fn0 "$LOG_FILE" | while read LINE; do
  if [[ "$LINE" == *"Test alert"* ]]; then
    echo "Match found! Pushing to CloudWatch..."
    
    # Unified the group and stream names to use the variables defined at the top
    aws logs put-log-events \
      --log-group-name "$LOG_GROUP" \
      --log-stream-name "$LOG_STREAM" \
      --log-events "[{\"timestamp\": $(date +%s%3N), \"message\": \"$LINE\"}]"
  fi
done
EOT
chmod +x /usr/local/bin/monitor_and_push.sh

nohup /usr/local/bin/monitor_and_push.sh > /var/log/monitor_push.log 2>&1 &

cat << 'EOF' | crontab -
*/1 * * * * /usr/local/bin/publish_CPU_metrics.sh >> /var/log/cron_monitoring.log 2>&1
*/1 * * * * /usr/local/bin/publish_RAM_metrics.sh >> /var/log/cron_monitoring.log 2>&1
*/1 * * * * /usr/local/bin/publish_disk_metrics.sh >> /var/log/cron_monitoring.log 2>&1
*/1 * * * * /usr/local/bin/publish_Latency_metrics.sh >> /var/log/cron_monitoring.log 2>&1
*/1 * * * * /usr/local/bin/publish_mysql_metrics.py >> /var/log/cron_monitoring.log 2>&1
*/1 * * * * /usr/local/bin/log_mysql_status.sh >> /var/log/mysql_status_cron.log 2>&1
EOF

echo "User-data script finished successfully at $(date)"