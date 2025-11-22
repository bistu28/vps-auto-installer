#!/bin/bash

# Colors
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m" # No Color

echo -e "${GREEN}==========================================${NC}"
echo -e "     SYSTEM INSTALLATION STATUS CHECK"
echo -e "${GREEN}==========================================${NC}"

# Generic function to check installed commands
check_installed() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "[${GREEN}✔${NC}] $1 is installed"
    else
        echo -e "[${RED}✖${NC}] $1 is NOT installed"
    fi
}

echo ""
echo "--- Checking Web Server Components ---"

# Standard checks
check_installed apache2
check_installed nginx
check_installed php

# Special check for php-fpm (because it's php8.1-fpm, php8.2-fpm, etc.)
echo -n "Checking php-fpm: "
if systemctl list-units --type=service | grep -q "php.*fpm"; then
    echo -e "[${GREEN}✔${NC}] php-fpm is installed"
else
    echo -e "[${RED}✖${NC}] php-fpm is NOT installed"
fi

# MySQL or MariaDB
if command -v mysql >/dev/null 2>&1; then
    echo -e "[${GREEN}✔${NC}] mysql is installed"
else
    echo -e "[${RED}✖${NC}] mysql is NOT installed"
fi

if command -v mariadb >/dev/null 2>&1; then
    echo -e "[${GREEN}✔${NC}] mariadb is installed"
else
    echo -e "[${RED}✖${NC}] mariadb is NOT installed"
fi

# Other tools
check_installed composer
check_installed node
check_installed npm
check_installed git
check_installed curl
check_installed ufw

# Supervisor special detection
echo -n "Checking supervisor: "
if command -v supervisord >/dev/null 2>&1 || systemctl list-unit-files | grep -q supervisor.service; then
    echo -e "[${GREEN}✔${NC}] supervisor is installed"
else
    echo -e "[${RED}✖${NC}] supervisor is NOT installed"
fi

echo ""
echo -e "${GREEN}==========================================${NC}"
echo " CHECK COMPLETE "
echo -e "${GREEN}==========================================${NC}"
