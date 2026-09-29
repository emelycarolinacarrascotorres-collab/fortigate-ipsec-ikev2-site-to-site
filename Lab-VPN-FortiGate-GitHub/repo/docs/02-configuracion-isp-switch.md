# 02 · Configuración de ISP y SW1 (CLI)

Archivos completos: [`configs/isp-altice-running-config.txt`](../configs/isp-altice-running-config.txt) · [`configs/sw1-running-config.txt`](../configs/sw1-running-config.txt)

## ISP-ALTICE (Cisco IOS)

- Hostname `ISP-ALTICE`, banner MOTD de acceso restringido.
- Acceso administrativo solo por **SSH v2** (`transport input ssh`, dominio `REDLOCA.COM`, RSA 1024), usuario local `admin` privilegio 15, `service password-encryption`.
- `exec-timeout 5 0` en consola y VTY.
- Interfaces con IPs públicas:

| Interfaz | Descripción | IP |
|---|---|---|
| gigabit 1/0 | FTG-A | 20.25.6.1/30 |
| gigabit 2/0 | FTG-B | 20.25.97.1/30 |

El ISP **no tiene rutas hacia las redes privadas** (10.25.x.x): solo conoce sus dos enlaces directos, por lo que únicamente puede reenviar el tráfico cifrado del túnel.

## SW1 (IOSvL2)

| Interfaz | Modo | Detalle |
|---|---|---|
| gigabit 0/0 | Trunk 802.1Q | VLAN 10 permitida — hacia FTG-A (port2) |
| gigabit 0/1 | Acceso | VLAN 10 — hacia PC1 |

```
vlan 10
interface gigabit 0/1
 switchport mode access
 switchport access vlan 10
interface gigabit 0/0
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10
```
