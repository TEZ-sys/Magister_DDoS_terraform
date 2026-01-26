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
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
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

(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_disk_metrics.sh") | crontab -

cat << 'EOT' > /usr/local/bin/publish_CPU_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
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

(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_CPU_metrics.sh") | crontab -

cat << 'EOT' > /usr/local/bin/publish_RAM_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
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
  --dimensions InstanceId=$INSTANCE_ID

EOT

chmod +x /usr/local/bin/publish_RAM_metrics.sh

(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_RAM_metrics.sh") | crontab -

cat << 'EOT' > /usr/local/bin/publish_Latency_metrics.sh
#!/bin/bash

NAMESPACE="Custom/System"
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
  --dimensions InstanceId=$INSTANCE_ID

EOT

chmod +x /usr/local/bin/publish_Latency_metrics.sh

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

try:
    cloudwatch = boto3.client('cloudwatch', region_name='${region}')
    
    db = mysql.connector.connect(
        host="localhost",
        user="monitor_user",
        password="YourSecurePassword123"
    )
    
    NAMESPACE = 'Custom/Application'
    INSTANCE_ID = os.popen('curl -s http://169.254.169.254/latest/meta-data/instance-id').read().strip()
    
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

# Add to cron (use root's crontab since we're already root)
(crontab -l 2>/dev/null; echo "*/1 * * * * /usr/local/bin/publish_mysql_metrics.py >> /var/log/mysql-metrics.log 2>&1") | crontab -

echo "User-data script completed at $(date)"