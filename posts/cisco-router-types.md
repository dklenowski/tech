Categories: networking 
            cisco
Tags: bri
      catalyst
      series

## Terms

### Fixed configuration routers ###

- Pre determined fixed LAN and WAN interface options.
- i.e. interfaces limited to factory installed (cannot be changed).
- If interface has errors must replace whole router.
- e.g. 2500 Series and below

### Modular routers                                  

- Built with 1 or more slots that allow customisation.
- Slot numbering left to right.
- Interface type displayed in the top left of the module
- e.g. 2E-2W (2 Ethernet, 2 WIC)
- e.g. 3600 Series

### Cisco WAN Interface Cards (WICs)               

#### Asynchronous serial                        

- Used with modem.
- Supports asynchronous dialup connections.

#### Synchronous serial

- Supports connections such as leased lines, frame relay and X.25

#### BRI

#### Channelized T1 / E1

- Supports leased lines, dial up, ISDN PRI and frame relay.

### Site Classification

#### Central Site

- aka headquarters
- Regional offices and telecommuters connect into for data.
- Requires many different types of WAN connections from remote locations.
- Considerations: multiple connections, access control, QoS, redundancy, scalability
- Cisco routers: Cisco 3600, 4000, AS5x00, 7000

#### Remote Site

- aka remote office / branch office (ROBOs)
- Smaller office located away from central site with smaller size WAN connection.
- Considerations: multiple connections, access control, redundancy, authentication, availability
- Cisco routers: Cisco 1600, 1700, 2500, 2600

#### Telecommuters

- aka Small Office / Home Office (SOHO)
- Small office with 1 to few employees (tend to use dialup services).
- Also mobile users (asynchronous dialup connections through carrier).
- Considerations: availability, authentication
- Cisco routers: Cisco 700 (760 or 770), 800, 1000

### Switch Site Classification

#### Access Layer 

- Workgroup / user access to network (merge into distribution devices).
- Low cost, high port densities.
- Catalyst 19xx, 2820, 29xx

#### Distribution Layer

- Layer 2, 3 functionality (either switch and router or multi layer switch).
- Defines broadcast boundaries (i.e. VLANs don’t extend beyond distribution switch).
- Policy based connectivity (security, address aggregation, inter VLAN routing etc).
- Catalyst 55xx, 6500

#### Core Layer

- Switch traffic as fast as possible (either frame, packet, cell technologies).
- No layer 3, used >= 2 or more switch blocks.
- Should not perform any packet manipulation (e.g. access lists, filtering).
- Because VLANs terminate at distribution device, core links are not trunk links and traffic is routed across the core.
- Catalyst 55xx, 65xx, 85xx
- 2 basic core designs:
  - Collapsed Core
      - Distributing / core layer functions on the same device.
      - Each access device 1 redundant link to the distribution layer switch.
      - All subnets terminate at layer 3 ports on the distribution switch.
      - Redundancy provided at layer 3 by HSRP.
  - Dual Core
      - Used >2 switch blocks and redundant connections required.
      - Core devices not linked to each other to avoid switching loops.
      - Provides 2 equal cost paths to each distribution switch.
      - Therefore twice the bandwidth.
      - Routing protocol used on layer 3 device determines the number of distribution devices that can be attached to the core.

## Cisco Router Types

### 700 Series

- ISDN BRI, basic telephone service ports.
- Set based IOS.
- Designed telecommuters, low cost, easy to manage, multi protocol ISDN routers.

### 800 Series

- ISDN BRI, basic telephone service ports, entry level IOS.
- Lowest prices routers based on Cisco IOS software.
- Used small office and corporate telecommuters.

### 1000 Series

- ISDN BRI (Cisco IOS and WAN options beyond ISDN).
- Remote office networking.

### 1600 Series

- ISDN BRI, 1 WAN interface card slot.

### 1700 Series

- 2 WAN interface card slots.

### 2500 Series

- Various ISDN BRI, serial and WAN interfaces.
- Usually fixed configuration.

### 2600 Series

- Various fixed LAN interface configurations, 1 network module slot, 2 WICs.
- Modular router.

        3600 Series                 Features
        3620                        2 WICs
        3640                        4 WICs
        3660                        6 WICs

### 4000 Series

- T1/ E1 ISDN PRI.
- Modular router.

### AS5000 Series

- Access server with multiple T1/E1 ISDN PRI and modem capabilities.

### 7200 Series

- Supports wide variety of WAN services with high port density.

## Cisco Switch Types
 
### Catalyst 65xx / 85xx

- Wire speed multicast forwarding and routing.
- Protocol Independent Multicast (PIM) for scalable multicast routing.

### Catalyst 6500

- Up to 384 * 10/100 Ethernet
- 192 * 100Base FX and 130 Gigabit Ethernet

### Catalyst 5500

- Set based switch
- Switch chassis has 13 slots
- Slot 1 is for the Supervisor Engine II model which provides switching, local and remote management, and dual fast Ethernet slots.
- Slot 2 contains an additional redundant Supervisor Engine II.
- Has a 3.6 Gbps media independent switch fabric and a 5 Gbps cell switch fabric the backplane provides connection between power supplies, supervisor Engine II, interface modules and the backbone module.
- Route Switch Module 
  - Builds on the route switch processor (RSP) featured in the Cisco 7500 routing platform.
  - High performance multilayer switching.

### Catalyst 4000 / 5000

- Set based CLI.
- < 96 ports, 10 / 100 Mbps Ethernet

### Catalyst 3000

- 16 port 10BaseT that has 2 open expansion bays that can be populated with 100BaseTX/FX, 10BaseFL, 10BaseT, 100VG-AnyLAN or ATM.
- Stackable, therefore up to 8 catalyst 3000 switches can be stacked together as one logical switching system.
- Catalyst 3500 uses Cisco IOS

### Catalyst 2900 ###

- 26 port fixed configuration fast Ethernet switch
- 24 * 10BaseT
- 2 * 100BaseTX
- Switch CLI

### Catalyst 1900

- 14 port fixed configuration switch.
- 12 * 10BaseT
- 2 * 100BaseTX
- Switch CLI

### Catalyst 1800

- Token ring switch that has 16 dedicated or shared ports in the base unit plus 2 feature card slots.
- Using the 4 port token ring UTP/STP feature cards, it supports 8 additional token ring ports.

 

