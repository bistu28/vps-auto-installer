#!/usr/bin/env bash
set -euo pipefail

DOMAIN="gearrent.cloud"
WSDOMAIN="ws.gearrent.cloud"
WEBROOT="/var/www/${DOMAIN}"
APACHE_VHOST="/etc/apache2/sites-available/${DOMAIN}.conf"
NGINX_VHOST="/etc/nginx/sites-available/${WSDOMAIN}.conf"
WEBSOCKET_DIR="/root/websocket"
WS_PORT=8081     # internal port for Workerman

echo "===== Updating System ====="
apt update -y && apt upgrade -y

echo "===== Installing Apache, PHP, MySQL ====="
apt install -y apache2 mysql-server
apt install -y php php-cli libapache2-mod-php php-mysql php-curl php-mbstring php-xml php-zip php-gd php-intl php-bcmath

a2enmod rewrite headers proxy proxy_http proxy_wstunnel ssl

echo "===== Preparing Webroot ====="
mkdir -p "$WEBROOT"
cat > ${WEBROOT}/index.html <<EOF
<html><body><h1 style='text-align:center;margin-top:40vh'>HI 👋 Website Installed Successfully!</h1></body></html>
EOF

chown -R www-data:www-data "$WEBROOT"

echo "===== Creating Apache VirtualHost ====="
cat > "$APACHE_VHOST" <<EOF
<VirtualHost *:80>
    ServerName ${DOMAIN}
    DocumentRoot ${WEBROOT}

    <Directory ${WEBROOT}>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${DOMAIN}-error.log
    CustomLog \${APACHE_LOG_DIR}/${DOMAIN}-access.log combined
</VirtualHost>
EOF

a2ensite "${DOMAIN}.conf"
systemctl reload apache2

echo "===== Installing Certbot ====="
apt install -y certbot python3-certbot-apache python3-certbot-nginx

echo "===== Getting SSL for main domain ====="
certbot --apache -d "$DOMAIN" --noninteractive --agree-tos -m admin@$DOMAIN

echo "===== Installing Composer ====="
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "===== Setting up Workerman WebSocket Server ====="
mkdir -p "$WEBSOCKET_DIR"
cd "$WEBSOCKET_DIR"

composer require workerman/workerman

cat > ${WEBSOCKET_DIR}/server.php <<EOF
<?php
require_once __DIR__ . '/vendor/autoload.php';
use Workerman\Worker;

\$ws = new Worker("websocket://0.0.0.0:${WS_PORT}");

\$ws->onMessage = function(\$connection, \$message){
    \$connection->send("Server Received: " . \$message);
};

Worker::runAll();
EOF

echo "===== Installing Supervisor ====="
apt install -y supervisor

cat > /etc/supervisor/conf.d/websocket.conf <<EOF
[program:websocket]
command=/usr/bin/php ${WEBSOCKET_DIR}/server.php start
autostart=true
autorestart=true
user=root
redirect_stderr=true
stdout_logfile=/var/log/supervisor/websocket.log
EOF

supervisorctl reread
supervisorctl update
supervisorctl start websocket

echo "===== Installing Nginx Only for WSS (port 443) ====="
apt install -y nginx

echo "===== Getting SSL for WebSocket Subdomain ====="
systemctl stop nginx || true
systemctl stop apache2 || true

certbot certonly --standalone -d "$WSDOMAIN" --noninteractive --agree-tos -m admin@$DOMAIN

systemctl start apache2

echo "===== Configuring Nginx Reverse Proxy for WSS ====="
cat > "$NGINX_VHOST" <<EOF
server {
    listen 443 ssl;
    server_name ${WSDOMAIN};

    ssl_certificate /etc/letsencrypt/live/${WSDOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${WSDOMAIN}/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:${WS_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host \$host;
    }
}
EOF

ln -sf "$NGINX_VHOST" /etc/nginx/sites-enabled/${WSDOMAIN}.conf
rm -f /etc/nginx/sites-enabled/default || true

nginx -t && systemctl restart nginx

echo "===== Allowing Firewall Ports ====="
ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw allow ${WS_PORT}
ufw --force enable

echo "========================================="
echo "INSTALLATION COMPLETE 🎉"
echo "Website: https://${DOMAIN}"
echo "WebSocket (WSS): wss://${WSDOMAIN}"
echo "Put your site files in: ${WEBROOT}"
echo "WebSocket folder: ${WEBSOCKET_DIR}"
echo "Supervisor log: /var/log/supervisor/websocket.log"
echo "========================================="

