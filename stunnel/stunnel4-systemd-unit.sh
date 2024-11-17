#!/bin/bash

echo "+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+-+"
echo "| S T U N N E L - 4  - y u e m y a z  - u b u n t u 2 4 . 0 4 |"
echo "+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+-+"

# Go to root directory
cd ~

# Default values for /etc/default/stunnel4
DEFAULT_STUNNEL4_CONFIG="ENABLED=1
FILES=\"/etc/stunnel/*.conf\"
OPTIONS=\"\"
PPP_RESTART=0
RLIMITS=\"\""

# stunnel.conf content
STUNNEL_CONF="pid = /var/run/stunnel.pid
cert = /etc/stunnel/stunnel.pem
[ssh]
accept = 444
connect = 127.0.0.1:22"

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install stunnel4
sudo apt install stunnel4 -y

# Configure /etc/default/stunnel4
echo "$DEFAULT_STUNNEL4_CONFIG" | sudo tee /etc/default/stunnel4 > /dev/null

# Configure /etc/stunnel/stunnel.conf
echo "$STUNNEL_CONF" | sudo tee /etc/stunnel/stunnel.conf > /dev/null

# Generate a 2048-bit SSL certificate
sudo openssl genrsa -out stunnel.key 2048
sudo openssl req -new -key stunnel.key -x509 -days 1000 -out stunnel.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=example.com"
sudo cat stunnel.crt stunnel.key > stunnel.pem
sudo mv stunnel.pem /etc/stunnel/

# Check if the certificate file is created successfully
if [[ ! -f /etc/stunnel/stunnel.pem ]]; then
  echo "Error: stunnel.pem file was not created successfully."
  exit 1
fi

# Allow port 444 through the firewall
sudo ufw allow 444/tcp

# Create a systemd unit file for stunnel
cat << EOF | sudo tee /etc/systemd/system/stunnel4.service > /dev/null
[Unit]
Description=SSL tunnel for stunnel
After=network.target

[Service]
ExecStart=/usr/bin/stunnel /etc/stunnel/stunnel.conf
PIDFile=/var/run/stunnel.pid
ExecReload=/bin/kill -HUP \$MAINPID
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the stunnel service
sudo systemctl enable stunnel4
sudo systemctl start stunnel4

# Check stunnel4 service status
if systemctl is-active --quiet stunnel4; then
  echo "Kurulum Tamamlandi: stunnel port 444 başarılı bir şekilde çalışıyor."
else
  echo "Error: stunnel4 servisi başlatılamadı."
  sudo journalctl -xeu stunnel4.service
fi
