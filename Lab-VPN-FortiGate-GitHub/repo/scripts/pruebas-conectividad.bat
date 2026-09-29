@echo off
REM Pruebas de conectividad desde PC1 (Windows) - VLAN 10
REM Ejecutar primero con el tunel VPN ACTIVO y luego con el tunel CAIDO.
ipconfig
ping 10.25.6.1
ping 10.25.97.1
ping 10.25.97.2
tracert -d 10.25.97.2
curl -k https://10.25.97.2
