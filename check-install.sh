#!/bin/bash

echo "=========================================="
echo "     SYSTEM INSTALLATION STATUS CHECK"
echo "=========================================="

# Function to check installation
check_installed() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "[✔] $1 is installed"
    else
        echo "[✖] $1 is NOT installed"
    fi
}

echo ""
echo "--- Checking Web Server Components ---"

check_installed apache2
check_installed nginx
check_installed php
check_installed php-fpm
check_installed mysql
check_installed mariadb
check_installed composer
check_installed node
check_installed npm
check_installed git
check_installed curl
check_installed ufw
check_installed supervisor

echo ""
echo "=========================================="
echo " CHECK COMPLETE "
echo "=========================================="

