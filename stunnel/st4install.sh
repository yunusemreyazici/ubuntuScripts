bu script dosyası "#!/bin/bash

echo "+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+-+"
echo "| S T U N N E L - 4  - y u e m y a z  - u b u n t u 2 4 . 0 4 |"
echo "+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+-+"

# Ana dizine geç
cd ~

# /etc/default/stunnel4 varsayılan değerleri
DEFAULT_STUNNEL4_CONFIG="ENABLED=1
FILES=\"/etc/stunnel/*.conf\"
OPTIONS=\"\"
PPP_RESTART=0
RLIMITS=\"\""

# stunnel.conf içeriği
STUNNEL_CONF="pid = /var/run/stunnel.pid
cert = /etc/stunnel/stunnel.pem
[ssh]
accept = 444
connect = 127.0.0.1:22"

# Sistemi güncelle ve yükselt
sudo apt update && sudo apt upgrade -y

# stunnel4 kurulumunu yap
sudo apt install stunnel4 -y

# /etc/default/stunnel4 dosyasını yapılandır
echo "$DEFAULT_STUNNEL4_CONFIG" | sudo tee /etc/default/stunnel4 > /dev/null

# /etc/stunnel/stunnel.conf dosyasını yapılandır
echo "$STUNNEL_CONF" | sudo tee /etc/stunnel/stunnel.conf > /dev/null

# /etc/stunnel/ altında 2048-bit SSL sertifikası oluştur
sudo openssl genrsa -out /etc/stunnel/stunnel.key 2048
sudo openssl req -new -key /etc/stunnel/stunnel.key -x509 -days 1000 -out /etc/stunnel/stunnel.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=example.com"
sudo cat /etc/stunnel/stunnel.crt /etc/stunnel/stunnel.key > /etc/stunnel/stunnel.pem

# Geçici sertifika ve anahtar dosyalarını sil
sudo rm -f /etc/stunnel/stunnel.key /etc/stunnel/stunnel.crt

# Sertifika dosyasının başarıyla oluşturulup oluşturulmadığını kontrol et
if [[ ! -f /etc/stunnel/stunnel.pem ]]; then
  echo "Hata: stunnel.pem dosyası başarıyla oluşturulamadı."
  exit 1
fi

# Güvenlik duvarında 444 numaralı porta izin ver
sudo ufw allow 444/tcp

# stunnel servisini manuel olarak başlat
sudo systemctl start stunnel4

# Çalışma durumunu kontrol et
if systemctl is-active --quiet stunnel4; then
  echo "Kurulum Tamamlandı: stunnel başarılı bir şekilde çalışıyor."
  echo "Port: 444"
else
  echo "Hata: stunnel başlatılamadı."
fi" 