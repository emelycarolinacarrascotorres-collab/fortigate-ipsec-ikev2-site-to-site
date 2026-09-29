#!/bin/bash
# Servidor Web Ubuntu - Apache2 con HTTPS (certificado autofirmado)
# IP: 10.25.97.2/28  GW: 10.25.97.1
# NOTA: script de referencia para reproducir el laboratorio.
set -e
sudo apt update && sudo apt install -y apache2 openssl
sudo a2enmod ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/lab-web.key -out /etc/ssl/certs/lab-web.crt \
  -subj "/C=DO/O=Laboratorio/CN=10.25.97.2"
sudo sed -i "s#/etc/ssl/certs/ssl-cert-snakeoil.pem#/etc/ssl/certs/lab-web.crt#; s#/etc/ssl/private/ssl-cert-snakeoil.key#/etc/ssl/private/lab-web.key#" /etc/apache2/sites-available/default-ssl.conf
sudo a2ensite default-ssl
sudo systemctl restart apache2
# Verificacion local: curl -k https://10.25.97.2
