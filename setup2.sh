#!/usr/bin/env bash
set -euo pipefail

############################################
# PRODUCTION MULTI-DOMAIN NGINX SETUP SCRIPT
# Domains:
#  - gnosiskaksha.in
#  - gnosiskaksha.cloud
# OS: Ubuntu 20.04 / 22.04
# Run as: root
############################################

### CONFIG ###
DOMAINS=("gnosiskaksha.in" "gnosiskaksha.cloud")
WEB_ROOT_BASE="/var/www"
PHP_VERSION=""   # auto-detect
LOG_PREFIX="[SETUP]"
############################################

log() {
  echo -e "${LOG_PREFIX} $1"
}

fail() {
  echo -e "${LOG_PREFIX} ERROR: $1" >&2
  exit 1
}

log "Starting production setup for multiple domains..."

############################################
# 1️⃣ SYSTEM PREPARATION
############################################
log "Updating system..."
apt update -y && apt upgrade -y

log "Checking required packages..."

ensure_pkg() {
  if ! dpkg -s "$1" >/dev/null 2>&1; then
    log "Installing missing package: $1"
    apt install -y "$1"
  else
    log "Package already installed: $1"
  fi
}

ensure_pkg nginx
ensure_pkg mysql-server
ensure_pkg software-properties-common
ensure_pkg curl

# PHP & PHP-FPM (auto-detect latest supported)
if ! command -v php >/dev/null 2>&1; then
  log "PHP not found, installing PHP..."
  add-apt-repository ppa:ondrej/php -y || true
  apt update -y
  apt install -y php php-fpm php-mysql php-cli php-curl php-mbstring php-xml php-zip php-gd
else
  log "PHP already installed"
fi

PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
PHP_FPM_SOCK="/run/php/php${PHP_VERSION}-fpm.sock"

ensure_pkg certbot
ensure_pkg python3-certbot-nginx

systemctl enable nginx mysql
systemctl start nginx mysql

############################################
# 2️⃣ WEBSITE DIRECTORY STRUCTURE
############################################
for DOMAIN in "${DOMAINS[@]}"; do
  ROOT_DIR="${WEB_ROOT_BASE}/${DOMAIN}/public_html"

  if [ ! -d "$ROOT_DIR" ]; then
    log "Creating directory structure for $DOMAIN"
    mkdir -p "$ROOT_DIR"
  else
    log "Directory already exists for $DOMAIN"
  fi

  chown -R www-data:www-data "${WEB_ROOT_BASE}/${DOMAIN}"
  chmod -R 755 "${WEB_ROOT_BASE}/${DOMAIN}"

  INDEX_FILE="${ROOT_DIR}/index.php"
  if [ ! -f "$INDEX_FILE" ]; then
    log "Creating test index.php for $DOMAIN"
    cat > "$INDEX_FILE" <<EOF
<?php
echo "<h1>${DOMAIN} OK</h1>";
echo "<p>PHP version: " . phpversion() . "</p>";
?>
EOF
  fi
done

############################################
# 3️⃣ NGINX CONFIGURATION
############################################
for DOMAIN in "${DOMAINS[@]}"; do
  CONF_FILE="/etc/nginx/sites-available/${DOMAIN}.conf"

  if [ ! -f "$CONF_FILE" ]; then
    log "Creating NGINX config for $DOMAIN"
    cat > "$CONF_FILE" <<EOF
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};

    root ${WEB_ROOT_BASE}/${DOMAIN}/public_html;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:${PHP_FPM_SOCK};
    }

    location ~ /\. {
        deny all;
    }
}
EOF
  else
    log "NGINX config already exists for $DOMAIN"
  fi

  if [ ! -L "/etc/nginx/sites-enabled/${DOMAIN}.conf" ]; then
    ln -s "$CONF_FILE" "/etc/nginx/sites-enabled/${DOMAIN}.conf"
  fi
done

log "Validating NGINX configuration..."
nginx -t || fail "NGINX configuration test failed"
systemctl reload nginx

############################################
# 4️⃣ SSL (LET'S ENCRYPT)
############################################
for DOMAIN in "${DOMAINS[@]}"; do
  if [ ! -d "/etc/letsencrypt/live/${DOMAIN}" ]; then
    log "Issuing SSL certificate for $DOMAIN"
    certbot --nginx \
      -d "${DOMAIN}" \
      -d "www.${DOMAIN}" \
      --non-interactive \
      --agree-tos \
      --register-unsafely-without-email \
      || fail "Certbot failed for $DOMAIN"
  else
    log "SSL certificate already exists for $DOMAIN"
  fi
done

log "Ensuring Certbot auto-renewal..."
systemctl enable certbot.timer
systemctl start certbot.timer

############################################
# 5️⃣ FINAL VALIDATION
############################################
log "Final NGINX validation..."
nginx -t || fail "Final NGINX test failed"
systemctl reload nginx

log "SUCCESS ✅"
log "Both domains are fully configured with:"
log "- NGINX"
log "- PHP ${PHP_VERSION} (FPM)"
log "- MySQL"
log "- HTTPS (Let's Encrypt)"
log "Script is idempotent and safe to re-run."
