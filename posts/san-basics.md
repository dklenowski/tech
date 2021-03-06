Categories: storage
            san
Tags: hba
      lu
      fc
      fibre


## Introduction

Reference: VMWare Infrastructure 3: Install and Configure Student Manual for ESX Server 3.5 and VirtualCenter 2.5

Fibre channel SAN consists of the following:

### Storage System

- Set of physical disks/disk array and 1 or more intelligent controllers
- Disk arrays storage processors aggregate physical disks into logical volumes, or LUNs, each with a LUN number identifier

### LUN (Logical Unit Number)

- Address of a Logical Unit (LU)
- LU is a unit of storage access and can be a JBOD, or a part of a JBOD, a RAID set (aka a storage container), or part of a storage container.
- Both a JBOD and a storage container can be partitioned into multiple LUNs
- A LU can also be a control function like an array gatekeeper LUN or tape controller

### SP (Storage Processor)

- Address of a Logical Unit (LU)
- Can partition a JBOD or RAID set into one or more Logical Unit Numbers (LUNs)
- Can restrict access access of a particular LUN to one or more server connections
- Each connection is reference by a server HBA's WWN (World Wide Name) and might also require defining the OS in the connection tables to adjust how the storage array controller presents FC and SCSI commands to a particular server.

### Host Bus Adapter (HBA)

- Connects the server to the FC network (i.e. to connect to the FC switch ports)
- Most times, 2 HBA adapters used for fault tolerant connections

### FC Switches

- >= 1 Fibre Channel (FC) switches for the Fibre Channel fabric.
- FC fabric interconnects multiple nodes
- Create packages from FC messages an add source/destination address to each packet.


## SAN Foundations

Reference: EMC SAN foundations

### Fibre Channel

- aka Serial SCSI-3 over Fibre Channel (FC), aka Fibre Channel Protocol (FCP)
- Serial data transfer interface.
- Operations over copper and/or optical fibre at rates up to 200 MB/s (high speed).
- Networking and IO protocols mapped to fibre channel constructs, and encapsulated and transported within Fibre Channel frames.
    
### Channels

- ESCON and SCSI are channel technologies that provide fixed between hosts and peripheral devices.
- These static connections are defined to OS in advance, and this tight coupling between transmission protocol and physical interface minimises overhead.
- Fibre channel is similar to networking in that:
  - Fibre channel fabric is a switch network, with a set of generic onto which host channel architectures and network architectures can be mapped.
  - Defined a layered communications architecture (simile to networking environments).
- Characters of channel technologies:
  - High performance
  - Low protocol overhead
  - Static configuration
  - Short distance
  - Connectivity within a single system

### Fibre Channel Stack

#### FC-0

- Lowest, defines physical link (including fibre), connectors, optical and electrical components.
- Each fibre is attached to a transmitter of a Port at one end and a recover of another Port at the other End

##### Multi-Mode Cable #####

- Dominant short distances 500m or less.
- Larger diameter than single mode fibre.
- Send multiple short wavelength signals through same fibre.

##### Single-Mode Cable

- Long distances (limited by power of laser of transmitter and the sensitivity of receiver)
- Send one longer wavelength down a much thinner cored fibre.

##### Host Bus Adapter

- IO adapter that sits between the hosts computer bus and the Fibre Channel loop and managers transfer of information between these two channels.
- i.e provides IO processing and physical connectivity between a server and storage.
- Storage may be attached using a variety of direct attached storage or storage networking technologies.
- Standard PCI or Sbus peripheral card on the host computer (like a SCSI adapter).

##### Optical Connector Specifications

- SC Connector - 1 GB/sec
- LC Connector - 2 GB/sec
        
#### FC-1

- Defines transmission protocol including serial encoding/decoding, special characters and error control
- Uses 8B/10B encoding


##### Fibre Channel Ports

- N_Port - Node port, port at end of a point-to-point link.
- NL_Port - Node Loop port, port which supports arbitrated loop topology.
- F_Port  - Fabric port, access point of Fabric which connects to a N_Port.
- FL_Port - Fabric Loop port, fabric port which connects to a NL_Port
- E_Port - Expansion port on a switch, links multiple switches
- G_Port - General Port (Connectix McData switch port with ability to function as either an F_Port or E_Port
- U_Port - Universal Port, Connectrix B series eqivalent to a G_Port.

- In environment using HBAs and Symmetrix FC Directors ports are configured as either N_Ports or NL_ports.
- Switch ports can be configured as F_Port, FL_Port, E_Port, G_Port, U_Port



##### Fibre Channel Topologies

###### Direct Connect

- Two devices directly (e.g. server directly connected to storage device).


###### Arbitrated Loop (FC-AL) Topology

- All devices are daisy chained in a loop (ring) over attachment ports called L_Ports (loop ports).
- Low cost ! (well to switches anyway!).
- Uses Fibre channel hubs.
- DISADV (Fibre channel hubs): Can only have 1 full duplex connection between port pairs at any one time (i.e. only 1 pair of ports can be active at any one time i.e. only 2 nodes in an FC-AL environment can be active at any time and they must be communicating with each other (pair))
- DISADV: Analogous to token ring (each device has to contend for loop via arbitration).

###### Switched Fabric (FC-SW) Topology

- Devices interconnected through Fibre channel switches.
- Frames are routed between source and destination by the "switch fabric"
- Uses fibre channel switch to route data between HBAs and fibre adaptors on storage system.
- Fabric is a single switch (or multiple switches) that interconnect various N_Ports.

#### FC-2

- Transport mechanism i.e. rules which nodes communication (e.g. data framing, frame sequencing, flow control and class of service).
- The actual data transported is transparent to FC-2 and only visible in FC-3 and above.
      
##### Frames

- All data passed in frames (max data 2112 bytes with total frame size of 2148 bytes).
- Exchange 
  - Uni/bi directional set of non-concurrent sequences. Exchange largest construct understood by FC-2.
- Sequence 
  - Sequence is contained within an Exchange and comprised of >= 1 frames. 
  - Sequence is unidirectional. 
  - FC-2 names each sequence and tracks each sequence to completion. 
  - Sequences used to re-order data when received at other end.

##### Fibre Channel Addressing

- 24 bits physical address.
- Not burned in, assigned when node enters the loop or is connected to the switch.
- Represents the physical address and generated in the Fabric Login (FLOG)
- Frames routed using physical address.
- Each N_Port has a fabric-unique identifier with the following layout
    
          FC_SW
          FC_SW
          FC_AL
          
          1. Switch
          2. Port in Switch
          3. AL_PA
    
  
- Domain ID (D_ID) 
  - Identifies the source/target switch in the fabric
- Switch Port (S_ID) 
  - Identifies source/target port in switch
- AL_PA 
  - Arbitrated Loop Physical Address, Used in Private Loop environment to identify the NL_Port. 
  - NB In private loop, domain and Switch port fields contain zeros.

##### Buffer Credits

- Fc-2 provides flow control for buffer management.
- When node initialised, operational parameters agreed upon (e.g.number of buffers i.e. buffer credits)
- Transmitting nodes can continue to transmit as long as there are buffer credits.
- i.e. Receiving port indicates its Buffer Credit. After sending this many frames, sending port must wait for a "Ready" indication (import for long distance links).


##### World Wide Name (WWN)

- 64 bit address to identify each element in fibre channel network.
- Assigned to the HBA or switch port by vendor (similar to MAC).
- Two designations of WWN (Both are globally unique 6 bit identifiers):
  - World Wide Port Name (WWPN)
    - Assigned to each physical port connected to the SAN (e.g. for hosts with multiple HBAs)
  - World Wide Node Name (WWNN)
    - Represents entire server, and derived form one of the WWPNs

##### Fabric Login

Three types of login supported in Fibre Channel:

###### Fabric Login (FLOGI) 

- All node ports must attempt to log in with the fabric (usually done after link/loop has been initialised). 
- e.g. N_Port or NL_Port and a F_Port or FL_Port
- Determines presence/absence of fabric.
- If fabric present, provides operating characters associated with entire fabric (e.g. CoS).
- If fabric present, will optionally assign or will confirm the native N_Port Identifier of the N_Port that initiated the login (i.e assigns an address to the port).
- If fabric present, initialises the buffer-to-buffer credit.
    

###### Port Login (PLOGI)

- For when an N_Port logs into another N_Port (e.g. HBA logs into an FA for instance).
- Before node port can communicate with another node port, must perform an N_Port login with that node port.
- Provides operating characteristics associated with the destination N_Port e.g. CoS
- With Class 3 services, buffer-to-buffer credit is initialised.
    
###### Process Login (PRLI)

- Establish sessions between related processes on a source and target N_Port (i.e. FC-4 layer applications).

#### FC-3

- Defines set of services to support advanced functions.
- Was put into Fibre Channel as a place holder.

#### FC-4

- Defines the Fibre Channel Link Encapsulation (FC-LE). i.e. designed to hand off to another protocol e.g. SCSI
- i.e. allow SCSI initiators and target to communicate

#### ULP (Upper Level Protocol)

- Not part of Fibre Channel e.g. SCSI-3, IP, ESCON/FIPS etc

### Zoning

- Partitions Fibre Channel switched fabric into subsets of logical devices.
- Zones contain set of members that permitted to access each other.
- Zone member identified by Source ID (SID), World Wide Name (WWN) or combination of both.
- EMC recommends that zones include only 1 HBA, however a HBA may belong to multiple zones.
- Zones may include >= 1 EMC Symmetric FA ports. 
- FA's may belong to multiple zones.

      
    
  


