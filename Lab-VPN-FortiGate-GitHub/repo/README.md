# Laboratorio VPN Site-to-Site IPsec con FortiGate (FTG-A ↔ FTG-B)

> **Autora:** Emely Carrasco · **Matrícula:** 2025-0697

## 🎬 Video demostrativo
(https://www.youtube.com/watch?v=2OKJWqRRx58)
---

## 📌 Propósito del laboratorio

Implementar y demostrar una **VPN IPsec Site-to-Site (IKEv2)** entre dos firewalls FortiGate a través de un ISP simulado, de modo que un **usuario** (VLAN 10, con DHCP) pueda comunicarse con un **servidor web HTTPS** ubicado en otra sede, y comprobar que **la comunicación solo fluye si el túnel VPN está activo**.

### Objetivos

1. Comunicar el usuario con el servidor web a través del enlace VPN.
2. Comprobar que el tráfico solo fluye con la VPN activa (rutas *blackhole* de respaldo que cortan el tráfico cuando el túnel cae).
3. Configurar en ambos FortiGate (**100 % por GUI**): interfaces, NAT, políticas de firewall, rutas estáticas y VPN Site-to-Site.
4. Configurar el ISP con IPs públicas, un servidor web HTTPS (/28) y un segmento de usuarios (/25) en VLAN 10 con DHCP y traceroute hacia el servidor.

## 🗺️ Topología

![Topología GNS3](images/topologia/topologia-gns3.png)

```mermaid
flowchart TB
    ISP(["ISP-ALTICE<br/>gi1/0: 20.25.6.1/30<br/>gi2/0: 20.25.97.1/30"])
    FA["FTG-A<br/>port1 (WAN): 20.25.6.2/30<br/>VLAN10_USUARIOS: 10.25.6.1/25<br/>port3 (mgmt): 192.168.99.1/24"]
    FB["FTG-B<br/>port1 (WAN): 20.25.97.2/30<br/>LAN-SERVER: 10.25.97.1/28<br/>port3 (mgmt): 192.168.98.1/24"]
    SW["SW1 (IOSvL2)<br/>VLAN 10"]
    PC["PC1 (Usuario)<br/>DHCP 10.25.6.12/25"]
    WEB["Servidor Web HTTPS<br/>10.25.97.2/28"]
    ISP ---|"20.25.6.0/30"| FA
    ISP ---|"20.25.97.0/30"| FB
    FA ---|"trunk 802.1Q VLAN 10"| SW
    SW ---|"acceso VLAN 10"| PC
    FB --- WEB
    FA <-. "Túnel IPsec IKEv2<br/>VPN-A-to-B ↔ VPN-B-to-A" .-> FB
```

## 🔐 Diagrama del túnel VPN

```mermaid
flowchart LR
    subgraph SEDE_A["Sede A - Usuarios"]
        U["USERS-NET<br/>10.25.6.0/25"]
    end
    subgraph SEDE_B["Sede B - Servidor"]
        S["SERVER-NET<br/>10.25.97.0/28"]
    end
    U --> A["FTG-A<br/>20.25.6.2"]
    A == "IPsec IKEv2 · DH14 · DES-SHA256" ==> B["FTG-B<br/>20.25.97.2"]
    B --> S
    A -. "ISP (solo transporta ESP cifrado)" .- B
```

## 📚 Contenido del repositorio

| Carpeta / archivo | Descripción |
|---|---|
| [`docs/01-direccionamiento.md`](docs/01-direccionamiento.md) | Redes, IPs, parámetros VPN y rutas |
| [`docs/02-configuracion-isp-switch.md`](docs/02-configuracion-isp-switch.md) | Configuración de ISP y SW1 (CLI) |
| [`docs/03-configuracion-fortigate-a.md`](docs/03-configuracion-fortigate-a.md) | FortiGate A por GUI (con capturas) |
| [`docs/04-configuracion-fortigate-b.md`](docs/04-configuracion-fortigate-b.md) | FortiGate B por GUI (con capturas) |
| [`docs/05-pruebas-y-verificacion.md`](docs/05-pruebas-y-verificacion.md) | Pruebas con VPN **activa** y **caída** |
| [`configs/`](configs/) | Running-configs de ISP, SW1, FTG-A y FTG-B |
| [`scripts/`](scripts/) | Scripts de pruebas y del servidor web |
| [`images/`](images/) | Todas las capturas usadas en la documentación |

## ✅ Resumen de resultados

| Prueba | VPN activa | VPN caída |
|---|---|---|
| Ping PC1 → Servidor (10.25.97.2) | ✅ 4/4 respuestas, TTL 62 | ❌ *Red de destino inaccesible* (10.25.6.1) |
| Tracert → Servidor | ✅ 3 saltos (10.25.6.1 → 20.25.97.2 → 10.25.97.2) | ❌ Se detiene en 10.25.6.1 |
| HTTPS al servidor | ✅ Página Apache2 | ❌ Tiempo de espera agotado |
| Estado IPsec (Monitor) | 🟢 Up | 🔴 Down |

**Conclusión:** la comunicación entre el usuario y el servidor solo existe mientras el túnel VPN está establecido.

## 🛠️ Tecnologías

GNS3 · FortiGate VM64-KVM · Cisco IOSv / IOSvL2 · Ubuntu + Apache2 · VPCS/Windows como cliente
