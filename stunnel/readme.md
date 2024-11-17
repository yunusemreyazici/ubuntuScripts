
# Stunnel Kurulum Scripti

Bu script, Ubuntu 24.04 üzerinde **stunnel** kurulumunu otomatikleştirmek için tasarlanmıştır. Script, gerekli yapılandırmaları yapar, SSL sertifikalarını oluşturur ve stunnel servisini başlatır.

## Özellikler
- **Stunnel kurulumu**: Gerekli paketleri yükler.
- **Otomatik yapılandırma**: `/etc/stunnel/stunnel.conf` dosyasını oluşturur ve yapılandırır.
- **SSL sertifikası oluşturma**: Geçici dosyalar kullanmadan doğrudan `/etc/stunnel/` altında 2048-bit SSL sertifikası oluşturur.
- **Güvenlik duvarı ayarları**: TCP 444 portunu güvenlik duvarında açar.
- **Servis yönetimi**: Stunnel servisini başlatır ve çalıştırma durumunu kontrol eder.

## Gereksinimler
- **Ubuntu 24.04** veya benzeri bir Debian tabanlı işletim sistemi
- `sudo` yetkilerine sahip bir kullanıcı

## Kullanım

### 1. Scripti İndirme
Script dosyasını bir dizine kaydedin (örneğin: `stunnel-setup.sh`).

### 2. Çalıştırma Yetkisi Verme
Script dosyasına çalıştırma izni verin:
```bash
chmod +x stunnel-setup.sh
```

### 3. Scripti Çalıştırma
Scripti aşağıdaki komutla çalıştırın:
```bash
sudo ./stunnel-setup.sh
```

## İşleyiş
Script aşağıdaki adımları gerçekleştirir:
1. Sistem paketlerini günceller ve yükseltir.
2. `stunnel4` paketini yükler.
3. `/etc/stunnel/` altında bir yapılandırma dosyası oluşturur:
   - **Dinlenen Port:** `444`
   - **Yönlendirilen Port:** `22` (SSH için)
4. **SSL sertifikası oluşturur** ve `/etc/stunnel/stunnel.pem` dosyasına kaydeder.
5. Geçici dosyaları temizler.
6. Stunnel servisini başlatır ve durumunu kontrol eder.

## Önemli Notlar
- **Dinlenen Port:** Script, varsayılan olarak TCP **444** portunu kullanır. Farklı bir port kullanmak istiyorsanız script içinde şu kısmı düzenleyebilirsiniz:
  ```bash
  [ssh]
  accept = 444
  connect = 127.0.0.1:22
  ```
- **Servis Başlatma:** Script, stunnel servisini `systemctl` ile başlatır. Manuel olarak başlatmak için aşağıdaki komutu kullanabilirsiniz:
  ```bash
  sudo systemctl start stunnel4
  ```

## Hata Ayıklama
- Eğer stunnel çalışmıyorsa, loglara bakarak sorunu teşhis edebilirsiniz:
  ```bash
  sudo journalctl -xeu stunnel4
  ```

## Lisans
Bu script MIT Lisansı altında yayınlanmıştır. Herkes kullanabilir, değiştirebilir ve dağıtabilir.
