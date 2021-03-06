Categories: networking
Tags: osi
      connection
      classful
      classless
      unreliable
      reliable

## Terms ##

### Transport Layer Protocols

#### Connection Orientated 

- Delivers messages from source to destination in correct order.
- Consists of 3 phases:
  - Connection setup.
  - Data transfer.
  - Connection teardown.
- e.g. TCP

#### Connectionless

- Each packet treated independently from all others.
- i.e. packets may take different routing paths etc
- Considered unreliable since no mechanism to ensure data was received.
- e.g. UDP


### Classfull Routing ###

- Used until CIDR in 1993.
- Defined in [RFC791](http://www.ietf.org/rfc/rfc791.txt)
- Occurs when a layer 3 device observes IP addressing class boundaries (A, B, C, D, E).
- e.g. older routing protocols RIP, IGRP

#### Address Classes ####

| Class | Begin Bit | Network Bits | Local Host Bits | Default Subnet Mask | Networks | Hosts |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| A | `0` | 7 (8 total) | 24 | 255.255.255.0 | 128 (2^7) | 16,777,216 (2^24) |
| B | `10` | 14 (16 total) | 16 | 255.255.0.0 | 16,384 (2^14) | 65,536 (2^16) |
| C | `110` | 21 (24 total) | 8 | 255.255.255.0 | 2,097,152 (2^21)  | 256 (2^8) |
| D | `1110` | | | Multicast |
| E | `1111` | | | Not Defined |


### Classless Routing ###

- Address is allocated a prefix mask which identifies the network portion of the address.
- NIC processes address without regard for bit boundary at class A, B, C.

### Subnetting ###

- Breaks a given network into smaller subnets.
- Host can obtain subnet mask by sending ICMP subnet mask request.
- Rules:
  - Network bit's don't have to be contiguous (but advisable).
  - Network bit's must not be all 0's or all 1's.
  - All hosts/routers at site must agree on addressing scheme.
  - For **classfull routing**
      - Decision on the number of bits allocated to network made once.
  - For **classless routing**
      - Mask held with subnet in routing table.
      - Decision on number of bits allocated to network made on router.
  - All hosts on internet treat subnet as *classfull routing* by incorporating subnet mask with default netmask.
- Subnet masks used before CIDR, but are still valid for route aggregation.

### Classless Interdomain Routing (CIDR) ###

- aka supernetting, route aggregation, prefix routing.
- Use mask shorter than the 'natural' mask to group contiguous IP addresses into single aggregate address.
- Routers use CIDR to implement VLSM.

- e.g. grouping 4 contiguous class C networks:

        131.181.112.0       1000 0011   1011 0101   0111 0000   0000 0000
        132.181.113.0       1000 0011   1011 0101   0111 0001   0000 0000
        133.181.114.0       1000 0011   1011 0101   0111 0010   0000 0000
        133.181.115.0       1000 0011   1011 0101   0111 0011   0000 0000

- the 'natural' class network mask is:

        255.255.255.0       1111 1111   1111 1111   1111 1111   0000 0000

- by shortening the mask 2 bits the resultant network mask is:

        255.255.252.0       1111 1111   1111 1111   1111 1100   0000 0000

- therefore the following network would represent all 4 networks (and could be advertised as a single route):

        131.181.112.0/22

- aka **route aggregation**
  - Use a single high level route to represent many lower level contiguous routes in the routing table.
  - Router will then advertise a single aggregate route.
- Routers must have access to both the network and the network mask.
- Rules for route advertisements:
  - Routing decisions performed on longest match basis.
  - Routing domain that performs summarisation must discard packets that do not match explicit routes that make up summarisation (to avoid routing loops).

### Variable Length Subnet Masks (VLSM) ###

- Use different network masks for the same major network.
- Note, older routing protocols (e.g. RIPV1, IGRP) do not support VLSM because they do not include the subnet masks in their routing table.
- Uses a **subnet mask indicator**
  - aka prefix
  - Shorthand method to include subnet mask associated with network address.
  - e.g.

              172.68.0.0/16   which is equivalent to 172.68.0.0/255.255.0.0

## OSI ##

### Modified TCP/IP - OSI ###

| Layer | Standard | Notes |
| :--- | :--- | :--- |
| 5. Application | HTTP, FTP etc |  |
| 4. Transport | TCP | Used for platform independence. |
| 3. Internet | IP | Used in routing. |
| 2. Data Link Layer (DLL) | PPP, SLIP, DSL | Network layer in OSI. Consists of the LLC/MAC sub layers. |
| 1. Physical | e.g. 100Base-TX | |


### 7. Application (data)

- Provides communication services. e.g. file transfer, terminal emulation, remote login etc
- e.g. WWW, SNMP, Telnet, SMTP

### 6. Presentation (data)

- Conversion between local syntax and transfer syntax.
- e.g. converts data from application layer to format that can be read by application layer on receiving computer.
- e.g. ASCII, HTML (text), Sound (MPEG, WAV), Video (AVI, Quicktime)

### 5. Session (data)

- Sets up and manages communication link/session.
- Responsible for synchronization points (dividing message into groups and if manages restart (from last point) if malfunction).
- Also specifies mode of communication (i.e. duplex).
- e.g. NetBIOS, RPC, NFS

### 4. Transport (segments) ###

- Delivers messages between transport service access points (TSAP/ports) between computers.
- i.e. a port is appended to message and is used to distinguish between different message streams.
- Also responsible for sizing packets (dependent on MTU of network).
- e.g. TCP/UDP

### 3. Network Layer (packets/datagrams) ###

- Appends network address of source and destination and also responsible for routing.
- Route determination and switching at this layer (e.g. Layer 3 routing protocols).
- e.g. ARP, DHCP, IP, BootP

### 2. Data Link Layer (DLL) (frames) ###

- Responsible for data movement across actual physical link to receiving node.
- Each host identified at DLL by hardware address burned into the nIC.
- IEEE 802.2 specification divides DLL into 2 sublayers:
  - **Media Access Control (MAC) Sublayer**
      - Regulate access to shared link using CSMA/CD (unreliable).
      - Controls when computer can send data.
      - Appends physical address of destination.
      - i.e. 802.2 Data Link Address
          - aka MAC address.
          - 48 bit (12 hex) burned into ROM of NIC.
          - Flat namespace (since MAC addresses should only have local significance).
  - **Logical Link Control (LLC) Sublayer**
      - Uses unreliable transmission of frames at MAC sublayer to implement error detection and reliable packet transfers between computers attached to a shared link.
      - e.g. Cyclic Redundancy Check's (CRC's)
- IEEE 802.3u (100BaseT) defines a single layer at the DLL and also defines the specification for the Physical Layer.
  - **Media Access Control (MAC) Sublayer**
      - Provides CSMA/CD for backward compatibility with half duplex networks, since with full duplex CSMA/CD is not required.
      - Provides an identical MAC format.
      - Defines error detection mechanisms (via a Frame Check Sequence (FCS))
- The Network Interface Card (NIC) implements the DLL (i.e. the LLC and MAC sublayers).
    - Filters messages on network for local workstation and inserts messages from local workstation into network.

### 1. Physical Layer (bits)

- Frames from DLL converted to bits and clocking information added.
- Bitstream then transmitted unreliably over link.
- The "link" consists of:
  - Transmitter.
  - Receiver
  - Physical Medium.
- The receiver must be synchronised with the transmitter (accomplished using a preamble at the start of the message).
- Defines physical, mechanical and functional specifications for activating and de activating the physical link between nodes on the network.
- Also defines the actual physical aspects of how cabling attached to computer NIC e.g. RJ-45


## Networking Communication ##

### Terms ###

#### Best Effort Delivery (at the Physical Layer)

- Hardware provides no information about whether the packet was delivered successfully.
- e.g. Ethernet

#### Best Effort Delivery (at the Network Layer)

- Internet software makes an earnest attempt to deliver packets.
- i.e. Internet does not discard packets capriciously; unreliability arises only when the resources are exhausted or underlying networks fail.
- e.g. IP

#### Unreliable (at the Network Layer)

- Delivery is not guaranteed.
- Packet may be lost, duplicated, delayed or delivered out of order but service will not detect such conditions, nor will it inform the sender or receiver.
- e.g. IP

#### Reliable (at the Transport layer)

- Guarantees to deliver a stream of data from one machine to another without duplication or data loss.

#### Flow Control and Windowing

- Ensure that segments are sent such a way that receiving computer not overwhelmed by the amount of data sent.
- Used to reduce congestion on the network.
- 3 basic methods used for flow control

##### 1. Buffering

- Occurs at network device (computer/router).
- Process allocates memory that is used to hold data waiting to be processed.
- Good for short bursts, BUT large amounts of data can cause buffer overflow.

##### 2. Congestion Avoidance

- Occurs when a device receives data at a rate that can overflow the buffer memory.
- Then the device sends a source quench message to the sending computer requesting that it reduce the current rate of data transmission.
- Can also be sent to tell sending computer to stop sending messages completely.
- Receiving computer must then send a “start” message to the sending computer when it ready to receive data again.

##### 3. Windowing

- Requires the sending and receiving computers agree on a window size that defines the number of packets that will be sent in each burst of data.

### Connection Orientated Communication

- Forms connection between 2 points.
- Delivers messages from source to destination in correct order.
- Involves 3 phases: a connection setup phase, a data transfer phase, and a connection teardown phase.
- Used by upper layer protocols that need a reliable connection.
- Advantages:
  - More reliable than connectionless.
  - Ability to apply QoS parameters at connection setup phase.
- Disadvantages:
  - Greater network overhead than connectionless (i.e. peer acknowledgements, flow control, windowing and error control).
- e.g. TCP

#### TCP Connection Setup ####

- aka 3 way handshaking.
- For reliable transfer TCP, TCP uses **Positive Acknowledgement with Retransmission**.
  - Requires recipient (receiver) to communicate with the source, sending back an acknowledgement (ACK) message as it receives data.
  - Sender keeps record of each packet it sends and waits for acknowledgement before sending the next packet.


##### 1. Server Prepared to accept incoming connections

- i.e. call's `socket`, `bind` and `listen` to bring socket into a **passive open** state.

##### 2. Client issues active open by calling `connect`

- Causes TCP client to send segment with the `SYN` (synchronise) flag set.
- Tells server clients initial sequence number for data that the client will send on connection.
- Usually no data, just headers

##### 3. Server acknowledgement

- Server acknowledges `SYN` and sends own `SYN` containing initial sequence number for data server will send on connection.
- Server sends its `SYN` and the `ACK` of the clients `SYN` on a single segment.

##### 4. Client acknowledgement

- Client must acknowledge the servers `SYN`.

### Connectionless Communication

- Each packet is treated independently from all others (& packets contain the source and destination address).
- Essentially unreliable, beset effort delay and connectionless.
- No form of flow control or other mechanisms for ensuring the dedication of network services.
- e.g. UDP at the transport layer and IP protocol at the network layer.
- Advantages:
  - Increased raw performance.
- Disadvantages:
  - No reliability.

#### UDP ####

- Connectionless, Best Effort Delivery.
- Does not use acknowledgements to make sure messages arrive, does not order incoming messages and it does not provide feedback to the control the rate at which information flows between machines.
- Therefore UDP messages can be lost, duplicated or arrive out of order.
- Furthermore, packets can arrive faster than the recipient can process them.
- Application that uses UDP accepts full responsibility for handling the problem of reliability, including message loss, duplication, delay, out of order delivery and loss of connectivity.







