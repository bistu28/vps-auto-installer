#!/bin/bash
set -e

echo "🚀 Starting Full VPS Setup (LEMP + SSL + Security)"

# ===== VARIABLES =====
DOMAIN="example.com"
EMAIL="your_email@example.com"
PHP_VERSION="8.2"

# ===== SYSTEM UPDATE =====
apt update && apt upgrade -y

# ===== BASIC TOOLS =====
apt install -y curl wget unzip zip software-properties-common ufw fail2ban

# ===== FIREWALL =====
ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw --force enable

# ===== NGINX =====
apt install -y nginx
systemctl enable nginx
systemctl start nginx

# ===== MYSQL =====
apt install -y mysql-server
systemctl enable mysql
systemctl start mysql

# ===== PHP =====
add-apt-repository ppa:ondrej/php -y
apt update
apt install -y php$PHP_VERSION php$PHP_VERSION-fpm php$PHP_VERSION-mysql php$PHP_VERSION-curl php$PHP_VERSION-mbstring php$PHP_VERSION-zip php$PHP_VERSION-gd php$PHP_VERSION-xml php$PHP_VERSION-cli

systemctl enable php$PHP_VERSION-fpm
systemctl start php$PHP_VERSION-fpm

# ===== WEBSITE DIRECTORY =====
mkdir -p /var/www/$DOMAIN
chown -R www-data:www-data /var/www/$DOMAIN
chmod -R 755 /var/www/$DOMAIN

# ===== NGINX CONFIG =====
cat > /etc/nginx/sites-available/$DOMAIN <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    root /var/www/$DOMAIN;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php$PHP_VERSION-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx

# ===== SSL (LET'S ENCRYPT) =====
apt install -y certbot python3-certbot-nginx
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m $EMAIL

# ===== AUTO RENEW SSL =====
systemctl enable certbot.timer

# ===== PHP OPTIMIZATION =====
sed -i 's/memory_limit = .*/memory_limit = 256M/' /etc/php/$PHP_VERSION/fpm/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 64M/' /etc/php/$PHP_VERSION/fpm/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$PHP_VERSION/fpm/php.ini

systemctl restart php$PHP_VERSION-fpm
systemctl restart nginx

# ===== FAIL2BAN =====
systemctl enable fail2ban
systemctl start fail2ban

# ===== DONE =====
echo "✅ VPS SETUP COMPLETE"
echo "🌐 Website root: /var/www/$DOMAIN"
echo "🔐 SSL enabled"
echo "🔥 Firewall active"
