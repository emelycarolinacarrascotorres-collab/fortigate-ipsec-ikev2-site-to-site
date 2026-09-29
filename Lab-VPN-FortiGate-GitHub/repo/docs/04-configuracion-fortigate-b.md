# 04 · Configuración de FortiGate B (FTG-B) — por GUI

Running-config: [`configs/fgt-b-running-config.conf`](../configs/fgt-b-running-config.conf)

## 1. Interfaces

WAN (port1) `20.25.97.2/30`, LAN-SERVER (port2) `10.25.97.1/28`, administración port3 `192.168.98.1/24`.

![Interfaces FTG-B](../images/fgt-b/01-interfaces.png)

## 2. Objetos de dirección

En FTG-B el objeto de la red del servidor se llama **FTG-B** (`10.25.97.0/28`).

| USERS-NET | FTG-B (red del servidor) |
|---|---|
| ![USERS-NET](../images/fgt-b/05-objeto-users-net.png) | ![FTG-B](../images/fgt-b/04-objeto-ftg-b.png) |

## 3. VPN IPsec

**Red (Fase 1):** gateway remoto `20.25.6.2` por port1.

![Network](../images/fgt-b/08-vpn-fase1-network.png)

**Autenticación:** Pre-shared Key, IKE v2.

![Autenticación](../images/fgt-b/09-vpn-fase1-autenticacion.png)

**Propuesta Fase 1:** DES / SHA256, DH 14, lifetime 86400 s.

![Fase 1](../images/fgt-b/10-vpn-fase1-proposal.png)

**Selectores Fase 2:** `10.25.97.0/28` ↔ `10.25.6.0/25`.

![Fase 2](../images/fgt-b/11-vpn-fase2-selectores.png)

**Resumen del túnel:**

![Resumen](../images/fgt-b/07-vpn-resumen-tunel.png)

![Túnel Up](../images/fgt-b/06-vpn-lista-tuneles.png)

## 4. Políticas de firewall

![Políticas](../images/fgt-b/03-politicas-firewall.png)

| Política | Origen → Destino | NAT |
|---|---|---|
| LAN-to-VPN | LAN-SERVER → VPN-B-to-A · FTG-B → USERS-NET | Deshabilitado |
| VPN-to-LAN | VPN-B-to-A → LAN-SERVER · USERS-NET → FTG-B | Deshabilitado |
| LAN-to-WAN | LAN-SERVER → port1 · all → all | Habilitado |
| Implicit Deny | any → any | — |

## 5. Rutas estáticas

![Rutas](../images/fgt-b/02-rutas-estaticas.png)

## 6. Logs de negociación

![Logs](../images/fgt-b/12-logs-vpn.png)
