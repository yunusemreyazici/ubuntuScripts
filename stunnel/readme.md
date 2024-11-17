# Açıklamalar

## Unit Dosyası İçeriği
- **ExecStart**: stunnel'i başlatır, konfigürasyon dosyasını belirler.  
- **Restart=always**: Servis kapanırsa otomatik olarak yeniden başlatılmasını sağlar.  
- **After=network.target**: stunnel'in ağ bağlantıları kurulduktan sonra başlatılmasını garanti eder.  

## Unit Dosyasının Oluşturulması
Script, `/etc/systemd/system/` dizininde `stunnel4.service` adlı bir dosya oluşturur. Bu dosya, systemd'e stunnel servisini nasıl başlatacağına dair talimatlar verir.

## Servisi Enable Etme
`sudo systemctl enable stunnel4` komutu ile `stunnel4` servisi sistem açılışında otomatik olarak başlatılacak şekilde yapılandırılır.

## Firewall Ayarları ve Sertifika Oluşturulması
- Port 444 açılır.  
- SSL sertifikası oluşturulur.

## Scripti Çalıştırma
1. Scripti bir dosya olarak kaydedin (örneğin `stunnel4-systemd-unit.sh`).  
2. Dosyaya çalıştırma izni verin:  
   ```bash
   chmod +x stunnel4-systemd-unit.sh
   ./stunnel4-systemd-unit.sh


Bu script, stunnel servisini düzgün bir şekilde yapılandıracak ve systemd üzerinden yönetebilmenizi sağlayacaktır.