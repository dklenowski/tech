Categories: networking 
            cisco
Tags: switch
      broadcast
      vlan
      trunking
      collision

## Overview ##

| Device | Collision Domain | Broadcast Domain |
| :--- | :--- | :--- |
| Repeater | One | One |
| Bridge | many (separates collision domains) | one (doesn't block broadcasts ) |
| Router | many | many (separate broadcast domain) |
| Switch | many | configurable (with VLAN's) |

### Broadcast Domain ###

- Defines the extent that broadcast packets propagate throughout the network.
- Broadcasts blocked only by router (i.e. router does not forward packets between subnets).
- In a broadcast domain, all devices communicate without the need for a router.
- e.g. ARP, NetBIOS name requests.
- **Broadcast Containment**
  - Routers
      - Many subnets, separate collision and broadcast domains.
      - Introduces bottleneck (since router changes header).
  - VLAN
      - Logical broadcast domain contained to ports on switch.
      - Require router to move between these "logical" broadcast domains.

#### Broadcast Storms ####

- Excessive broadcasts have negative impact on network performance.
- Solution is to segment network into separate broadcast domains using routers or switches with VLAN's.

### Collision Domain ###

- Boundary of shared environment (where every device see's packet).
- e.g. hub/repeater extends the collision domain.
- For a switch, each switch port is considered a collision domain, therefore the port can be full duplex.

### Flooding ###

- Frame is flooded out all ports in the broadcast domain (except for the source port) including trunk ports.
- e.g. a frame that is a multicast/broadcast frame or a frame with a destination MAC that is not in a bridge/switch MAC table.

### Bridges ###

- Operate at DLL (layer 2).
- Forwarding decisions based on bridging table (of MAC addresses).
- Table built by sampling packets received on all ports for each segment of the network.
- If traffic local (on same segment), bridge does not forward traffic and instead drops the traffic (assumes the frames have reached there local destination).
- **Transparent** Bridges are used on ethernet networks.
- Advantage: Logically separate network segments and reduces broadcast storms.
- Disadvantage: If traffic large on destination segment, must wait to forward frame (increasing latency).
- **Transparent Bridge**
  - Transparent to devices in network.
  - Requirements:
      1. Does not modify frames that are forwarded.
      2. Always listening and learning (to build bridging table).
      3. Must forward all packets out all ports except the port that initially received the broadcast.
      4. If destination unknown, floods all ports (except port that initially received the broadcast).

### Switches ###

- Operate at DLL (layer 2).
- Advantage: greater port density (than bridges).
- Disadvantage: Forwards broadcast and multicast packets to all nodes (which can lead to broadcast storms).
- 3 main functions:
  1. **Address Learning** - As the MAC address table is initially empty.
  2. **Frame Forwarding** - Switch receives with known destination will forward out appropriate port without flooding.
  3. **Loop Avoidance** - Using STP.
- Modes:
  - **Store and Forward**
    - Switch copies entire frame into memory buffer and stores packet until it processes CRC.
    - High latency but reduces frames with with errors entering network.
  - **Cut Through Switching**
    - Reads destination of frame, checks switching table and immediately forwards frame out appropriate port.
    - Lower latency than Store and Forward, but can introduce frames with errors on the network.
  - **Fragment Free**
    - Compromise between Store and Forward and Cut Through.
    - Switch reads first 64 bytes of frame into buffer to check before forwarding frame.
    - Can reduce the number of damaged packets on the network.

#### Layer 2 Switching ####

- Hardware based bridging using ASIC's.
- No modification to layer 2 between like layer 1 interfaces.
- Layer 2 switching and bridging logically equivalent.
- Disadvantage: Broadcast/multicast radius increases as the number of hosts increase.
- Disadvantage: STP limitations (slow convergence and blocked links).

#### Layer 3 Switching ####

- Hardware based routing using ASIC's.
- Similar traditional router:
  1. Determines forwarding path using Layer 3 information.
  2. Validates integrity of layer 3 via checksums.
  3. Updates forwarding statistics in MIB.
  4. Applies security if required.
- Difference between a Layer 3 switch and a router lie in its physical implementation.

#### Layer 4 Switch ####

- Layer 3 switching/routing that considers application.
- e.g. TCP/UDP port numbers, QoS etc

#### Inter VLAN Routing ####

- i.e. **Router on a Stick**

##### Routing Switch #####

- Uses hardware to create shortcuts to route packets through layer 3 network.
- Does not use routing protocols.
- aka **Multilayer Switch (MLS)**
  - Combines layer 2/3/4 switching.
  - Moves traffic at wire speed while satisfying routing requirements (removes traditional router bottlenecks).
  - Makes same modifications to packets (e.g. TTL decrement), therefore standards compliant.

##### Switching Routers #####

- A switch that runs a routing protocol.
- Typically on general purpose CPU.

## Virtual LAN's (VLAN's) ##

- Group devices in the same layer 2 broadcast domain.
- Logical subnets (therefore requires layer 3 device to communicate between subnets/VLAN's).
- VLAN membership based on port/MAC address.
- Cisco recommends:
  - A one-to-one correspondence between VLAN's and IP subnets.
      - e.g. for a 24 bit subnet mask (254 hosts allowed in subnet) there should be no more than 254 devices in 1 VLAN.
  - VLAN's should not extend outside the layer 2 domain of the distribution switch.
- Advantages:
  - Network security.
  - Control broadcast distribution.
  - Bandwidth utilisation.
  - Faster than routers.

### IEEE 802.1Q ###

- Defines how switches store MAC addresses.
- Defines 2 types of VLAN's:
  - **1. Shared VLAN (SVL)**
    - Bridge ethernet traffic based on MAC address (not VLAN ID's).
  - **2. Independent VLAN (IVL)**
    - Bridge ethernet traffic based on VLAN ID and MAC address.
    - Overcome issues where multiple customer have devices with the same MAC address.

### VLAN Boundaries ###

#### End to End VLAN's ####

- Exists end to end networks spanning entire switch fabric.
- Therefore layer 2 switching throughout the entire network.
- VLAN membership the same as user moves throughout the network.
- Each VLAN should have the same 80/20 traffic pattern flows.

#### Local VLAN's ####

- Create VLAN's based on geographic location.
- Easier to manage than end to end VLAN's.
- Overcomes the 80/20 problems in End to End VLAN's

### VLAN Membership ###

#### Port Based VLAN Membership ####

- aka static VLAN's
- Port assigned to a specific VLAN statically.

#### Dynamic VLAN's ####

- Allows VLAN membership based on MAC address.
- e.g. CiscoWorks

### VLAN Links ###

#### Access Link ####

- Link member of only 1 VLAN ("native" VLAN of the port).
- Device that is attached is unaware of the VLAN (i.e. switch responsible for inserting/stripping switch information from frame's).
- Port not capable of sending/receiving from another VLAN unless routed.

#### Trunk Link ####

- Allow information from >1 VLAN to communicate over the link.

## Trunking

- Multiplexes traffic from multiple VLAN's over a single link (used for interconnection).
- On Cisco switches:
  - Trunk link capabilities are hardware dependent, use `show port capabilities`.
  - Trunk links can have a native VLAN (if the trunk link fails) although the trunk link does not belong to any specific VLAN.

| Identification Method | Encapsulation | Frame Tagging | Media |
| :--- | :--- | :--- | :--- |
| Inter Switch Link (ISL) | Yes | Yes (Cisco proprietary) | Ethernet |
| IEEE 802.1Q | No | Yes(Inserts ID into frame header) | Ethernet |
| 802.10 (Cisco Proprietary) | Non | No | FDDI |
| LAN Emulation (LANE) | No | No | ATM |

### Trunking Protocols

#### Trunking ####

- Specifies how to encapsulate and tag data transported over trunk ports.
- Enables switches to multiplex traffic from multiple VLAN's over a common trunk link.

##### ISL

- Cisco proprietary trunk encapsulation for fast ethernet or gigabit ethernet interfaces.

##### 802.1Q

- IEEE standard for carrying VLAN's over fast ethernet or gigabit ethernet trunks.
- Is a subset of the Cisco 802.1Q implementation.

#### Negotiation 

- Used for negotiation of trunk links between Cisco switches.

##### DISL #####

- Cisco first generation trunk establishment protocol used to enable the configuration of trunks at the other end of a switch link/s.
- No support for 802.1Q

##### DTP #####

- Cisco second generation trunk establishment protocol.
- Provides options for using either 802.1Q or ISL as the trunk encapsulation type.

#### Communication ####

- Share information about VLAN's in the management domain over trunk links.

##### VTP #####

- Cisco proprietary method for distribution of VLAN information across a management domain.

### Cisco ISL

- Either fast ethernet or gigabit ethernet links.
- Encapsulates user data and identifies source VLAN for each frame.
  - 26 byte header containing 10 it VLAN ID added to each frame.
  - 4 byte tail added to perform CRC check.
- Allows receiving frame to  be constrained to same VLAN as source.
- Uses **frame tagging**:
  - Uniquely assigns user defined ID (VLAN ID) to header (only if frame forwarded out trunk link).
  - If **trunk link** switch maintains VLAN ID and forwards frame out trunk link port.
  - If **access link** switch removes VLAN ID before transmitting frame to host.

### IEEE 802.1Q

- Defines architecture for VLAN's and the service it provides.
- Header Fields:
  1. MAC Address (48 bits)
  2. Tag Protocol Identifier (TPID) (2 bytes) 
      - Fixed value, indicates frame carries 802.1Q/80.1P frame information.
  3. Tag Control Information (2 bytes) 
      - 3 bit user priority
      - 1 bit canonical format (CFI indicator)
  4. VLAN Identifier (21 bits)
  5. Initial Type/Data
  6. New CRC

### ISL Verses 802.1Q

- Both ISL and 802.1Q use explicit tagging (frame explicitly assigned VLAN information).
- But tagging mechanisms differ:
  - ISL
      - Uses external tagging.
      - Original frame not altered, encapsulated with new 26 byte ISL header and new extra 4 byte FCS (i.e. doesn't modify Layer 2 FCS).
      - Therefore may violate ethernet standards
          - e.g. if maximum frame size of 1518 bytes, will add its headers making 1522 bytes).
          - Considered **baby giant** and may generate ethernet error but will still be processed.
  - 802.1Q
      - Uses internal tagging.
      - i.e. modifies layer 2 frame with extended header and recalculates FCS.
      - Therefore frames appear as standard ethernet frame.

## MultiLayer Switching (MLS) ##

- Cisco's ethernet based routing switch technology for IP traffic.
- Supported on high end Catalyst switches (e.g. 5000/6000).
- e.g. 
  - For Catalyst 5000,  MLS accomplished using the NetFlow Feature Card (NFFC) I or II to provide hardware assisted routing.
  - For Catalyst 6000, MLS accomplished using the Multilayer Switch Feature Card (MSFC) in conjunction with the Policy Feature Card (PFC).
- MLS uses 3 components:
  1. **MLS Route Processor (MLS-RP)**  
      - Acts as the router in the network.
      - Handles the first packet in every flow.
      - i.e. the router in the network.
  2. **MLS Switching Engine (MLS-SE)**
      - Used to build shortcut entries in a Layer 3 CAM table.
      - i.e. the NFFC.
  3. **MLS Protocol (MLSP)**                     
      - Lightweight protocol used to initialise the MLS-SE and notify it of changes in the Layer 3 topology or security requirements.

### MLS Process

1. MLSP hello packets sent by the router.
2. NFFC identifies candidate packets.
3. NFFC identifies enable packets.
4. NFFC shortcuts future packets.

### NetFlow Feature Card (NFFC)          

- Basically a pattern matching engine (i.e. by matching on various combinations of addresses and port numbers, the routing switch form of Layer 3 switching can be performed).
- Can also be used for IGMP snooping, QoS and traffic classification and differentiation.
- Is a caching technique (and therefore does not run any routing protocols).
  - i.e. Uses pattern matching capabilities to discover packets that have been sent to a router (running a routing protocol) and then sent back to the same Catalyst Switch.
  - This allows the NFFC to shortcut future packets in a manner that bypasses the router.
  - i.e. shortcuts packets following the same path (or flow).

### Layer 2 CAM Table

- A form of bridging table commonly used in modern switches.
- Use the `show cam` command to view the CAM table.

## VLAN Trunking Protocol (VTP)

- Cisco proprietary protocol.
- Layer 2 multicast protocol for maintaining Catalyst VLAN information over trunk links.
- Advantages:
  - VLAN configuration consistency throughout across networks (additions ,deletions, and renaming).
  - Mapping scheme for traversing mixed media backbones e.g. Ethernet VLANs to ATM etc
  - Ensures integrity of the spanning tree algorithm in the VTP domain.

### VTP Modes of Operation

- Both server and transparent remember VLAN information, therefore if power cycled, clients only activate VLAN 1 (other ports will remain in suspended state until switch receives VTP advertisements from server authorising a set of VLANs).

#### server

- Default mode.
- Create, modify, delete (global) VLANs
- Specifies configuration parameters (e.g. VTP version) for entire VTP domain
- Advertises configuration / VLAN information to other switches

#### client                      

- Behaves the same as server, but cannot create/modify VLANs.
- i.e. wont be allowed and information will not be propagated.

#### transparent            

- Does not advertise its VLAN configuration (local configuration) and does not synchronise.
- Therefore if add VLAN, information will not be propagated to other switches.
- Does still forward VTP advertisements out trunk ports.

### VTP Advertisements

- Sent out on trunk ports to multicast address `01-00-0C-CC-CC-CC` and SNAP type `0x2003`.
- Always travel on the default VLAN for the media i.e.

        Ethernet      VLAN1
        FDDI          VLAN1002

- Cisco routers understand trunking protocols but do not participate in VPT (discarded).

#### Summary Advertisement              

- Server sends summary advertisement every time topology change occurs and before subset advertisement OR every 300s on default VLAN
- Format:

        Field Name                              Bytes     Description
        Version                                 1         VTP version (either 1 or 2).
        Type                                    1         Summary advertisement.
        Number of Advertisements to Follow      1
        Domain Name Length                      1
        Management Domain Name                  32        Zero padded.
        Configuration Revision Number           4         Each time VTP server modifies its VTP database
                                                          (addition, deletion) server increments its configuration
                                                          revision number (N + 1).
                                                          Server then advertises this new configuration revision number.
                                                          If config revision number higher than number stored
                                                          server will make request of the updater for a subset
                                                          advertisement.
        Updater Identifier                      4         Originating IP address.
        update timestamp                        12
        MD5 Digest hash code                    16

#### Subset advertisements  

- Servers will send subset information after a VLAN configuration change occurs.
- Changes that will trigger subset advertisement:
  - Creation/deletion of VLAN.
  - Suspending/activating VLAN.
  - Changing the name of a VLAN.
  - Changing the MTU of a VLAN.
- Format:

        Field Name                              Bytes     Description
        Version                                 1
        Type                                    1
        Subset Sequence Number                  1
        Domain Name Length                      1
        Management Domain Name                  32        Zero padded.
        Configuration Revision Number           3
        VLAN Information Field 1
        ..
        VLAN Information Field N

- Format for VTP VLAN Information Field:

        Field Name                              Bytes     Description
        Information Length                      1
        VLAN Status                             1
        VLAN Type                               1
        VLAN Name Length                        1
        ISL VLAN ID                             2
        MTU Size                                2
        802.10 SAID                             4
        VLAN Name                               32        Zero padded.


#### Advertise Requests from Clients 

-  VTP client requests any lacking VLAN information.
- e.g. if client rest and database cleared. change domain membership, advertisement with a higher configuration revision number.
- Server then responds with summary and subset advertisements.
- Format:

        Field Name                              Bytes     Description
        Version                                 1
        Type                                    1
        Reserved                                1
        Domain Name Length                      1
        Management Domain Name                  32        Zero padded.
        Starting Advertisement to Request

#### VTP Join Message

- Used for VTP Pruning.

## Spanning Tree Protocol (STP)

- Used to prevent:
  - Broadcast bridging loops (that increase exponentially).
  - Bridge table corruption (if host temporarily removed from network and bridge table entries have not been flushed, can cause bridge table corruption and loops).
- Layer 2 protocol (IEEE 802.1d standard).
- Uses the Spanning Tree Algorithm (STA):
  - Selects reference point in network and calculates redundant paths to that reference point.
  - If redundant, STA chooses which link will forward and which will block.
  - If segment down, STA reconfigures topology and re establishes link by activating standby path.

### Notes on transparent bridging (Ethernet switching) operation

- Bridge has no initial location of any device.
  - Bridge listens to frames coming into each of its ports to figure out on which network a device resides.
  - Bridge assumes that the source device is located behind the port of that frame (using the source address of the frame).
  - As listening process continues, bridge builds a table of source MAC addresses and the bridge port numbers associated with them.
  - Bridge can update bridging table if new MAC address or device changed ports.

- If bridge receives broadcast frame as destination (must forward / flood) the frame out all available ports.
  - The frame not forwarded out the port that initially received the frame.
  - i.e. bridge only separates collision domains, not broadcast domains (except with VLANs).

- Frames that are forwarded across the bridge cannot be modified.

### Bridge Protocol Data Units (BPDUs)

- Used to gather information about switched network
- Switch sends out BPDU every 2 sec                 

        source address        MAC address of the port.
        destination address   Well known STP multicast address.
                              01-80-c2-00-00-00

- 2 types of BPDUs:
  - Configuration BPDU - used for spanning tree computation.
  - Topology Change Notification (TCN) BPDU - Used to announce changes in the network topology.

### STP Operation ###

#### 1. Elect Root Bridge               

- uses bridge ID to elect root bridge, consists of `<bridge_priority>.<mac_address>`.
- bridge priority (2 bytes):
  - Weight of switch in relation to all other switches.
  - Range 0 - 65 535 (default 32 768 on Catalyst switches).
- MAC address.

##### Process                  

1. Switch powers up and initially assumes it is the root bridge and sends out BPDUs with the root bridge ID (BID) and sender BID equal to its own BID.
2. Received BPDU messages are analysed to see if "better" root bridge (i.e. a lower bridge ID).
3. When switch hears a better root bridge, replaces its own root BID with the root bridge announced in the BPDU.

##### Notes

- Each VLAN (because it is a separate broadcast domain) must have its own root bridge (root bridge for different VLANs can reside on one/many switches).
- If all switches have the same bridge priority, switch with the lowest MAC address will be elected as the root bridge.
- Root bridge is an ongoing processes, triggered by root bridge ID changes in the BPDUs (e.g. if new switch with lower MAC address powers up, will begin advertising itself as the root bridge and since lower BID, all switches will reconsider and record it as the new root bridge).

##### root bridge requirements   
                 
- Should be the most centralised switch in the network.
- Should be the least disturbed switch in the network.
- e.g. backbone switches because less likely to be disturbed during moves/ changes in the network.

#### 2. Elect Root Ports

- aka root association
- Each non root switch must figure out where it is in relation to the root switch.
- Each non root switch must select 1 root port.

##### Root Path Cost

- Cumulative cost of all links leading to the root bridge.
- This value is carried in the BPDU.
- Sum of all links that were crossed to get to the root bridge.
- Calculated by adding receiving ports path cost to the value in the BPDU as the BPDU comes into the switch port (not as they go out).

##### Path Cost

- Cost associated to switch link.
- Only known locally to switch (i.e. not in the BPDU).
- In general the higher the bandwidth of the link, the lower the cost.

        Link (Mbps)   Old STP cost (linear)     New STP cost (non linear)
        4             250                       250
        10            100                       100
        16            63                        62
        45            22                        39
        100           10                        19
        155           6                         14 

##### Process

1. Root bridge sends out BPDU with root path cost of zero out all ports (0 because ports on root bridge).
2. Next closest neighbour receives BPDU, adds path cost of its own port where the BPDU arrived.
3. The neighbour sends out the BPDU with the new cumulative root path cost.
4. Value is incremented by subsequent switch port path costs as the BPDU is received by each switch on down the line.
5. After incrementing root path cost, switch records in memory.
6. When a BPDU arrives on another port and has a root path cost that is lower than the previously recorded value, this lower value becomes the new root path cost.
  - selection process for root port

              root path cost      To root switch
              port ID             Used as tie breaker, lower port ID wins

  - Note when a switch receives BPDUs on multiple ports, indicates that the switch has redundant links.

7. the port with the lowest root path cost becomes the root port.
8. all other ports that are receiving BPDUs are placed in blocking mode.
  - i.e. can receive BPDUs but cannot send / receive data.

#### 3. Elect Designated Ports

- one designated port on each network segment.
- e.g. if 2 switches share a common network segment, only 1 switch should be allowed to forward traffic to/from that segment (the designated switch).
- i.e. if 2 ports connected either directly or indirectly will have 1 designated port.
- Designated port selection based on the cumulative root path cost to the root bridge.
- Switch with the designated port for a segment call the designated switch all active ports on a root switch are designated ports.

##### Process

1. Switch announces its root path cost in its BPDU
2. If a neighbouring switch on a shared LAN segment sends a BPDU announcing a lower root path cost neighbour must have the designated port.
3. If the switch only learns of high root path costs from other BPDUs received on a port, assumes that its receiving port is the designated port.

##### STP decision process          

- In each determination process above, if 2 or more links have identical root path costs and use the below conditions to determine the winner:

  1. Lowest Root Bridge ID (BID)
  2. Lowest root path cost to the root bridge
  3. lower sender BID
  4. lowest port ID

- Must move down the list from where you start:
  - e.g. for root bridge selection, since lowest BID is first criteria, lowest root path cost will be next.
  - e.g. for DP selection, since lowest root path cost is first criteria, lowest sender BID will be second.

### STP States

- When STP enabled, every switch in VLAN goes through transitional states at power on:

#### Disabled                 

- administratively shut down (not part of the transitional states).

#### a. Blocking            

- After initialised of switch, port initially in blocking to avoid switching loops.
- Cannot receive/transmit data and cannot add MAC addresses to table can only receive BPDUs.
- Blocks for `MaxAge`.

#### b. Listening 

- Moves from blocking to listening if switch thinks that port can be selected as either root port or designated port.
- Port cannot send/receive data.
- Port can send / receive BPDUs.
- If port looses its root port or designated port status, is returned to the blocking state listens for `ForwardDelay`.

#### c. Learning

- Port can send/receive BPDUs as well as being able to learn new MAC addresses to add to its bridge table
- Learns for `forwardDelay`.

#### d. Forwarding

- Can now send / receive data, collect MAC addresses into table and send/receive BPDUs.
- Note switch port can only reach forwarding if there are no redundant links and if the port is a root port or designated port.


### BPDU Timers

- STP uses 3 timers to make sure that network converges before a bridging loop can incorrectly form.
- Timers used to force ports to wait for correct topology information.
- Default timers based on <= 7 switch diameter (measured from the root switch with the root switch counting as 1).
- Cisco recommends that you change switch diameter, rather than changing individual timers.


#### `Hello`

- Default (802.1d) is 2 sec.
- Time interval between configuration BPDUs sent from root bridge.
- `hello` time value configured on the root bridge will determine the hello time for all non root switches because they relay configuration BPDUs as they are received from the root.
- All non root switches have a locally configured hello timer that used to time TCN BPDUs when they are retransmitted.

        Switch (enable) set spantree hello <time>

#### `ForwradDelay`

- Default is 15 sec.
- Time switch port spends in listening and learning states.

        Switch (enable)  set spantree fwddelay <delay:4-30s> <vlan>

#### `MaxAge`

- Default is 20 sec.
- Time interval that switch stores a BPDU before discarding it.
- i.e. each switch port keeps copy of the best BPDU that it has heard.
- If the source of BPDU loses contact with the switch port, switch will notice that a topology change has occurred after the `MaxAge` elapses and BPDU is aged out.

        Switch (enable)  set spantree maxage <agingtime> <vlan>



### Topology Change Notification (TCN) BPDUs

- Topology change occurs when switch either moves a port into the forwarding state or moves a port from the forwarding or learning state into the blocking state.

#### Process                  

1. Port on active switch comes up / goes down.
2. Switch sends a TCN BPDU out its designated port.
  - BPDU carries no data, only informs recipients that a change has occurred
  - Note, switch will not send TCN BPDUs if the port has been configured with `portfast` enabled.
3. Switch will continue sending TCN BPDUs every hello time interface until it gets an acknowledgement from an upstream neighbour.
4. As the upstream neighbours receive the TCN BPDU, they will propagate it on toward the root bridge.


### Spanning Trees

- 802.1Q defined standard that specified single instance spanning tree for all VLANs.
- Disadvantage (of single spanning tree):
  - Precludes load balancing and can lead to interconnectivity in certain VLANs.
- Advantages:
  - Simpler design and lighter load on CPU.
- Alternatives are specified below.
 
#### 1. Common Spanning Tree (CST)

- 802.1Q standard.
- Single instance spanning tree.
- STP runs on VLAN 1 (with single root bridge).
- Advantages:
  - Fewer BPDUs.
  - Less processing on switch.
- Disadvantages:
  - Single root bridge (therefore may use less optimal paths).
  - As number of ports increases, longer convergence times.

#### 2.  Per VLAN Spanning Tree (PVST)

- Cisco proprietary i.e. requires ISL.
- STP maintains separate instance STP for every VLAN.
- Max 64 VLANs.
- Therefore each VLAN has unique STP topology (root, port cost, path cost and priority).
- Advantages:
  - Overall size of spanning tree decreased.
  - Increased scalability and convergence time.
  - Faster recovery and better reliability.
- Disadvantages:
  - Increased load on root switch (for spanning tree maintenance).
  - Increased bandwidth on trunk links (for BPDUs).

#### 3. Per VLAN Spanning Tree + (PVST+)

- Adds support for links across 802.1Q CST
- “plug and play” i.e. no new configuration.
- Tunnels PVST BPDUs across CST as multicast.
- Checks port and VLAN inconsistencies etc.

### UplinkFast

- Allows blocked port to begin forwarding immediately when switch detects.
- Failure of current forwarding link.
- Decreased convergence time and disruption.

#### Requirements

1.  Uplinkfast must be enabled.
2.  Switch must have at least 1 blocked port.
3.  Failure must be on root port.



