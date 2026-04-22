#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -euo pipefail
echo "=== Starting MySQL bootstrap ==="

SECRET_NAME="mysql/credentials"
AWS_REGION="eu-west-2"

apt-get update -y
apt-get install -y mysql-server jq awscli nginx

SECRET_JSON=$(aws secretsmanager get-secret-value \
    --secret-id "$SECRET_NAME" \
    --region "$AWS_REGION" \
    --query 'SecretString' \
    --output text)

DB_USER=$(echo "$SECRET_JSON" | jq -r '.secret_username')
DB_PASS=$(echo "$SECRET_JSON" | jq -r '.secret_password')

systemctl enable mysql
systemctl start mysql

mysql --user=root <<-MYSQL
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$${DB_PASS}_root';
    CREATE USER IF NOT EXISTS '$${DB_USER}'@'%' IDENTIFIED BY '$${DB_PASS}';
    GRANT ALL PRIVILEGES ON *.* TO '$${DB_USER}'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
MYSQL

systemctl restart mysql

mkdir -p /etc/nginx/ssl

echo "$SECRET_JSON" | jq -r '.ssl_certificate'  > /etc/nginx/ssl/nginx.crt
echo "$SECRET_JSON" | jq -r '.ssl_private_key'  > /etc/nginx/ssl/nginx.key

chmod 600 /etc/nginx/ssl/nginx.key
chmod 644 /etc/nginx/ssl/nginx.crt

openssl x509 -in /etc/nginx/ssl/nginx.crt -noout -subject -dates \
    && echo "✓ Certificate OK" \
    || echo "✗ Certificate parse FAILED — check secret format"

openssl rsa -in /etc/nginx/ssl/nginx.key -check -noout \
    && echo "✓ Private key OK" \
    || echo "✗ Private key parse FAILED — check secret format"

cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name _;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name _;

    ssl_certificate     /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    root  /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

#mkdir -p /var/www/html
#cat <<'EOF' > /var/www/html/index.html
#<h1>DevOps Task: Success</h1>
#<p>Secrets successfully retrieved from AWS Secrets Manager.</p>
#<p>SSL Certificate is active.</p>
#EOF

#chown -R www-data:www-data /var/www/html
#chmod -R 755 /var/www/html

nginx -t && systemctl restart nginx \
    && echo "✓ Nginx restarted OK" \
    || echo "✗ Nginx config test FAILED — see above"