#!/bin/bash

set -e

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
WORKDIR="/tmp/server-backup-$TIMESTAMP"
FINAL_ARCHIVE="/root/full-server-backup-$TIMESTAMP.tar.gz"

mkdir -p "$WORKDIR"

echo "======================================"
echo " Starting Full Server Backup"
echo "======================================"

# Website files

if [ -d /var/www ]; then
cp -a /var/www "$WORKDIR/"
fi

# Nginx

if [ -d /etc/nginx ]; then
cp -a /etc/nginx "$WORKDIR/"
fi

# SSL

if [ -d /etc/letsencrypt ]; then
cp -a /etc/letsencrypt "$WORKDIR/"
fi

# PHP

if [ -d /etc/php ]; then
cp -a /etc/php "$WORKDIR/"
fi

# SSH

if [ -d /etc/ssh ]; then
cp -a /etc/ssh "$WORKDIR/"
fi

# Crontab

crontab -l > "$WORKDIR/root-crontab.txt" 2>/dev/null || true
cp /etc/crontab "$WORKDIR/" 2>/dev/null || true

# Database backup

echo "Creating MySQL dump..."
mysqldump --single-transaction --routines --triggers --events 
--all-databases > "$WORKDIR/all-databases.sql"

# Docker info

docker ps -a > "$WORKDIR/docker-containers.txt" 2>/dev/null || true
docker images > "$WORKDIR/docker-images.txt" 2>/dev/null || true
docker volume ls > "$WORKDIR/docker-volumes.txt" 2>/dev/null || true

# Find compose files

find / -name "docker-compose.yml" 2>/dev/null > "$WORKDIR/docker-compose-files.txt" || true
find / -name "compose.yml" 2>/dev/null >> "$WORKDIR/docker-compose-files.txt" || true

# System info

uname -a > "$WORKDIR/system-info.txt"
df -h > "$WORKDIR/disk-usage.txt"
free -h > "$WORKDIR/memory-info.txt"

# Create final archive

echo "Compressing backup..."
tar -czpf "$FINAL_ARCHIVE" -C "$WORKDIR" .

# Cleanup

rm -rf "$WORKDIR"

echo ""
echo "======================================"
echo " BACKUP COMPLETED SUCCESSFULLY"
echo "======================================"
echo "Backup File:"
echo "$FINAL_ARCHIVE"
echo ""
ls -lh "$FINAL_ARCHIVE"
