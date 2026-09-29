# 01 · Direccionamiento y parámetros

## Redes

| Red | Rango | Máscara | Uso |
|---|---|---|---|
| Enlace ISP ↔ FTG-A | 20.25.6.0/30 | 255.255.255.252 | IP públicas lado usuarios |
| Enlace ISP ↔ FTG-B | 20.25.97.0/30 | 255.255.255.252 | IP públicas lado servidor |
| Usuarios (VLAN 10) | 10.25.6.0/25 | 255.255.255.128 | Hosts .1 a .126 |
| Servidor Web | 10.25.97.0/28 | 255.255.255.240 | Hosts .1 a .14 |
| Administración FTG-A | 192.168.99.0/24 | 255.255.255.0 | Solo gestión (port3) |
| Administración FTG-B | 192.168.98.0/24 | 255.255.255.0 | Solo gestión (port3) |

## Equipos e interfaces

| Equipo | Interfaz | Dirección IP | Gateway |
|---|---|---|---|
| ISP | gi1/0 (hacia FTG-A) | 20.25.6.1/30 | n/a |
| ISP | gi2/0 (hacia FTG-B) | 20.25.97.1/30 | n/a |
| FTG-A | port1 (WAN) | 20.25.6.2/30 | 20.25.6.1 |
| FTG-A | port2.10 VLAN10_USUARIOS (LAN) | 10.25.6.1/25 | n/a |
| FTG-A | port3 (administración) | 192.168.99.1/24 | n/a |
| FTG-A | Túnel VPN-A-to-B | sin IP (sobre port1) | n/a |
| FTG-B | port1 (WAN) | 20.25.97.2/30 | 20.25.97.1 |
| FTG-B | port2 LAN-SERVER (LAN) | 10.25.97.1/28 | n/a |
| FTG-B | port3 (administración) | 192.168.98.1/24 | n/a |
| FTG-B | Túnel VPN-B-to-A | sin IP (sobre port1) | n/a |
| Servidor Web | eth0 | 10.25.97.2/28 | 10.25.97.1 |
| PC de usuario | DHCP (VLAN 10) | 10.25.6.10 – 10.25.6.100 (ej. 10.25.6.12) | 10.25.6.1 |
| PC de administración (Windows) | Ethernet | 192.168.99.10/24 | sin gateway |

## Parámetros de la VPN

| Parámetro | FTG-A (VPN-A-to-B) | FTG-B (VPN-B-to-A) |
|---|---|---|
| Remote Gateway | 20.25.97.2 | 20.25.6.2 |
| Interfaz | port1 | port1 |
| Fase 2 Local | 10.25.6.0/25 | 10.25.97.0/28 |
| Fase 2 Remote | 10.25.97.0/28 | 10.25.6.0/25 |
| IKE | v2 | v2 |
| Fase 1 | DES-SHA256, DH grupo 14, lifetime 86400 s | igual |
| NAT Traversal | Disable | Disable |
| DPD | On Demand · 3 reintentos · 20 s | igual |
| PSK | *(definida en el laboratorio; no se publica)* | igual |

## Rutas estáticas

| Equipo | Destino | Interfaz / Gateway | Distancia |
|---|---|---|---|
| FTG-A | 0.0.0.0/0 | port1 / 20.25.6.1 | 10 |
| FTG-A | 10.25.97.0/28 | VPN-A-to-B | 10 |
| FTG-A | 10.25.97.0/28 | Blackhole | 254 |
| FTG-B | 0.0.0.0/0 | port1 / 20.25.97.1 | 10 |
| FTG-B | 10.25.6.0/25 | VPN-B-to-A | 10 |
| FTG-B | 10.25.6.0/25 | Blackhole | 254 |

### ¿Por qué la ruta *Blackhole*?

La ruta hacia la red remota por el túnel tiene distancia 10. Si el túnel cae, esa ruta se desactiva y entra la ruta **Blackhole (distancia 254)**, que descarta el tráfico. Sin ella, el paquete saldría por la ruta por defecto hacia el ISP **sin cifrar** (o sería descartado por el ISP). Así se garantiza que **la comunicación solo fluye si la VPN está activa**.
