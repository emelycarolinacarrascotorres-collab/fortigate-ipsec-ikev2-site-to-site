# 03 · Configuración de FortiGate A (FTG-A) — por GUI

Running-config: [`configs/fgt-a-running-config.conf`](../configs/fgt-a-running-config.conf)

## 1. Interfaces (Network → Interfaces)

WAN (port1) `20.25.6.2/30`, administración port3 `192.168.99.1/24` y LAN VLAN10_USUARIOS `10.25.6.1/25` sobre port2 (servidor DHCP 10.25.6.10 – 10.25.6.100).

![Interfaces FTG-A](../images/fgt-a/01-interfaces.png)

## 2. Objetos de dirección (Policy & Objects → Addresses)

| USERS-NET | SERVER-NET |
|---|---|
| ![USERS-NET](../images/fgt-a/10-objeto-users-net.png) | ![SERVER-NET](../images/fgt-a/09-objeto-server-net.png) |

## 3. VPN IPsec (VPN → IPsec Tunnels → Custom)

**Red (Fase 1):** gateway remoto estático `20.25.97.2` por WAN (port1), NAT-T deshabilitado, DPD On Demand.

![Network](../images/fgt-a/05-vpn-fase1-network.png)

**Autenticación:** Pre-shared Key, IKE versión 2.

![Autenticación](../images/fgt-a/06-vpn-fase1-autenticacion.png)

**Propuesta Fase 1:** DES / SHA256, DH grupo 14, lifetime 86400 s.

![Fase 1](../images/fgt-a/07-vpn-fase1-proposal.png)

**Selectores Fase 2:** `10.25.6.0/25` ↔ `10.25.97.0/28`.

![Fase 2](../images/fgt-a/08-vpn-fase2-selectores.png)

Túnel en estado **Up**:

![Túnel Up](../images/fgt-a/04-vpn-lista-tuneles.png)

## 4. Políticas de firewall (Policy & Objects → Firewall Policy)

| Política | Origen → Destino | NAT |
|---|---|---|
| LAN-to-VPN | VLAN10_USUARIOS → VPN-A-to-B · USERS-NET → SERVER-NET | Deshabilitado |
| VPN-to-LAN | VPN-A-to-B → VLAN10_USUARIOS · SERVER-NET → USERS-NET | Deshabilitado |
| LAN-to-WAN | VLAN10_USUARIOS → WAN (port1) · all → all | **Habilitado** |
| Implicit Deny | any → any | — |

El NAT se deshabilita en las políticas del túnel para no alterar las direcciones que coinciden con los selectores de Fase 2.

![Políticas](../images/fgt-a/03-politicas-firewall.png)

## 5. Rutas estáticas (Network → Static Routes)

![Rutas](../images/fgt-a/02-rutas-estaticas.png)

## 6. Monitoreo

![IPsec Monitor](../images/fgt-a/11-ipsec-monitor-up.png)

![Logs VPN](../images/fgt-a/12-logs-vpn.png)
