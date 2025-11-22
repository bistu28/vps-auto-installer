# 🚀 Full Server Auto-Setup Script

### Apache Website + Nginx WSS + Workerman + SSL + Supervisor

For **gearrent.cloud** and **ws.gearrent.cloud**

This project provides a **one-command automatic installer** that sets up a complete production server on **Ubuntu** with:

* 🔥 **Apache** (main web server)
* 🔒 **HTTPS (SSL)** via Let’s Encrypt
* 🛰 **Nginx** (reverse-proxy dedicated for WebSocket WSS)
* ⚡ **Workerman PHP WebSocket Server**
* ♻ **Supervisor** (auto-restart websocket)
* 🗂 Automatic folder structure
* 🎉 Fully ready to deploy a live PHP/HTML website

After installation:

* Website loads at → **[https://gearrent.cloud](https://gearrent.cloud)**
* WebSocket server runs at → **wss://ws.gearrent.cloud**

---

# 📦 Features

### ✔ Fully automated Ubuntu server installation

No manual configuration. Everything is set for production.

### ✔ Apache for the website

Your site files go into:

```
/var/www/gearrent.cloud
```

### ✔ Nginx ONLY for secure WebSocket (WSS)

Browser connects using:

```
wss://ws.gearrent.cloud
```

### ✔ Workerman PHP WebSocket server

Runs internally on port `8081`, managed by Supervisor.

### ✔ Supervisor auto-restart

If websocket crashes → it restarts automatically.

### ✔ Let’s Encrypt SSL

Both domains installed automatically:

* gearrent.cloud
* ws.gearrent.cloud

### ✔ UFW firewall configured

Secure defaults enabled.

---

# 📌 Requirements

1. VPS running **Ubuntu 22+ / 24+ / 25+**
2. Domain pointed to the VPS:

| Host              | Type | Value       |
| ----------------- | ---- | ----------- |
| gearrent.cloud    | A    | Your VPS IP |
| ws.gearrent.cloud | A    | Your VPS IP |

3. Run script as **root**

---

# 🚀 Installation

### 1️⃣ Download the script directly from GitHub

```bash
curl -o setup.sh https://raw.githubusercontent.com/USERNAME/server-setup-gearrent/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

> Replace **USERNAME** with your GitHub username.

---

# 📂 After Installation

### ✔ Website Directory

Upload your site files to:

```
/var/www/gearrent.cloud
```

### ✔ Test Website

Open:
👉 [https://gearrent.cloud](https://gearrent.cloud)

---

### ✔ Test WebSocket

From browser console:

```javascript
let ws = new WebSocket("wss://ws.gearrent.cloud");

ws.onopen = () => ws.send("hello server");
ws.onmessage = e => console.log("Received:", e.data);
```

Expected output:

```
Received: Server Received: hello server
```

---

# 🛠 Useful Commands

### Check websocket status

```bash
sudo supervisorctl status websocket
```

### Check websocket logs

```bash
sudo tail -f /var/log/supervisor/websocket.log
```

### Restart WebSocket manually

```bash
sudo supervisorctl restart websocket
```

### Restart Apache / Nginx

```bash
sudo systemctl restart apache2
sudo systemctl restart nginx
```

---

# 🗄 MySQL Setup (Optional)

Login:

```bash
sudo mysql -u root
```

Create DB:

```sql
CREATE DATABASE mydb CHARACTER SET utf8mb4;
CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON mydb.* TO 'myuser'@'localhost';
FLUSH PRIVILEGES;
```

---

# 🔐 Firewall Rules (Auto-configured)

Allowed:

* SSH (22)
* HTTP (80)
* HTTPS (443)
* WebSocket internal (8081)

---

# 🧩 Folder Structure

```
/var/www/gearrent.cloud       → Website files
/root/websocket               → Workerman server
/root/websocket/server.php    → WebSocket logic
/etc/supervisor/conf.d/       → Supervisor configs
/etc/nginx/sites-available/   → WSS nginx config
/etc/apache2/sites-available/ → Website confg

---
