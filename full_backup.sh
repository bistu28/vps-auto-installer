#!/bin/bash

set -e

BACKUP_DIR="/root/server-backup"
FINAL_ARCHIVE="/root/full-server-backup-$(date +%Y%m%d-%H%M%S).tar.gz"

echo "Creating backup directory..."
mkdir -p "$BACKUP_DIR"

echo "Backing up websites..."
tar -czf "$BACKUP_DIR/websites.tar.gz" /var/www 2>/dev/null || true

echo "Backing up nginx..."
tar -czf "$BACKUP_DIR/nginx-config.tar.gz" /etc/nginx 2>/dev/null || true

echo "Backing up SSL certificates..."
if [ -d /etc/letsencrypt ]; then
tar -czf "$BACKUP_DIR/ssl-certificates.tar.gz" /etc/letsencrypt
fi

echo "Backing up PHP configuration..."
if [ -d /etc/php ]; then
tar -czf "$BACKUP_DIR/php-config.tar.gz" /etc/php
fi

echo "Backing up SSH configuration..."
tar -czf "$BACKUP_DIR/ssh-config.tar.gz" /etc/ssh

echo "Backing up crontabs..."
crontab -l > "$BACKUP_DIR/root-crontab.txt" 2>/dev/null || true
cp /etc/crontab "$BACKUP_DIR/" 2>/dev/null || true

echo "Backing up database list..."
mysql -u root -e "SHOW DATABASES;" > "$BACKUP_DIR/databases.txt" 2>/dev/null || true

echo "Dumping all MySQL/MariaDB databases..."
mysqldump --all-databases > "$BACKUP_DIR/all-databases.sql" 2>/dev/null || true

echo "Backing up Docker information..."
docker ps -a > "$BACKUP_DIR/docker-containers.txt" 2>/dev/null || true
docker images > "$BACKUP_DIR/docker-images.txt" 2>/dev/null || true

echo "Finding docker compose files..."
find / -name "docker-compose.yml" > "$BACKUP_DIR/compose-files.txt" 2>/dev/null || true

echo "Creating final archive..."
tar -czf "$FINAL_ARCHIVE" -C /root server-backup

echo ""
echo "======================================="
echo "BACKUP COMPLETE"
echo "Archive Location:"
echo "$FINAL_ARCHIVE"
echo "======================================="
ls -lh "$FINAL_ARCHIVE"
