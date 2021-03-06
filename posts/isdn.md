Categories: networking
Tags: isdn
      cisco
      ntu

## Introduction

### ISDN Basic Rate Interface (BRI)/ Digital Signal Level 0 (DS0) Interface

- 2 B(64 Kbps) + 1 D(16 kbps)
- Framing and synchronisation overhead = 48 Kbps
- Total speed = 192 Kbps

### ISDN Primary Rate Interface (PRI)

#### America / Japan (T1)    

- 23 B (64 Kbps) + 1 D (64 Kbps)
- Framing and synchronisation overhead = 8 Kbps
- Total speed = 1.544 Mbps
- D channel carried in timeslot 24

#### Australia / Europe (E1)   

- 30 B (64 Kbps) + 1 D (64 Kbps)
- Framing and synchronisation = 64 Kbps
- Total speed = 2.048 Mbps
- D channel carried in timeslot 16
          
## ISDN Components

### ISDN Terminals  

- Between network and ISDN.
- Terminal Endpoint Device-type 1 (TE1)
  - ISDN compatible, connects (NT1 / NT2) using 4 wire, twisted pair digital link.
- Terminal Endpoint Device-type 2 (TE2)
  - Requires TA (Terminal Adapter) to connect to ISDN.
  - TA 
    - Standalone or inside TE2.
    - Serial to ISDN (e.g. JTEC : EIA/TIA-232 to ISDN).

### Termination devices

- Connected to either the TE1 or TA.

#### NTU 

- Network Termination Unit
- NT1 + NT2

#### NT1 

- Network Termination 1
- Connects 4 wire ISDN subscriber wiring to conventional 2 wire local loop facility.
- i.e. converts ISDN BRI signals for use over the actual line.
- Part of the local exchange in Australia (part of CPE in US).

#### NT2 

- Network Termination 2
- Intelligent device, performs switching and concentration.
- e.g. PBX

#### LT  

- Line Termination
- Located on the exchange side (functions identical to NT1)

#### ET

- Exchange termination
- Subscriber line card in the ISDN exchange
- NB LT and ET also called Local Exchange (LE)

### ISDN Reference Points Designation

#### R (rate)      

- Between TE2 and TA.
- e.g. EIA-TIA-232, V.35, X.21 on TE2

#### S (system)  

- Between TE1 or TA and NT2.
- S and T same characteristics.

#### T (terminal)  

- Between NT1 (e.g. CSU/DSU) and NT2 (e.g. PBX) or between NT1 and TE1 (if no NT2).

#### U (user)  

- Between NT1 / NTU and ISDN network (LT)
- 2 wire circuit ANSI T1.601 or I.431 std

#### S/T     

- No NT2
- Between TE1 or TA and NTU (I.430)
- 8 wire connector, allow for powering the NT and TE capabilities.

## OSI ##

- ISDN covers layer's 1-3 in OSI.

| OSI | D Channel | B Channel |
| :---: | :---: | :---: |
| Network | DSS (Q.930 and Q.931) aka I.450 and I.451 | IP |
| DLL (X.25) | LAPD (Q.920 and Q.921) | HDLC, PPP, FR, LAPB |
| Physical | I.430 (BRI) / I.431 (PRI) ||

### Layer 3

- Call control between TE and local switch (D channel) i.e. manage connections.
- I series specifications, support end terminal e.g. Cisco router
- Q series specifications, support from network e.g. central switch
- e.g. messages : CONNECT, RELEASE, USER INFORMATION
- Note, these protocols not supported / implemented in the NT equipment.
- Note, when troubleshooting, different ISDN switches use different call setup and teardown procedures, therefore must specify correct switch type when configuring.

### Layer 2

- Q.920 functional specification, Q.921 actual implementation (D channel).
- Consists Link Access Procedure, D channel (LAPD) (Similar HDLC e.g. frame formats).
- Allows devices communicate over D channel (control, signaling information, delivery).
- Terminal Endpoint identifier (TEI)
    - Addressing mechanism, assigned carrier.
- Service access point identifier (SAPI)
    - Differentiates processes / devices running on the same NT1.
    - Mapping between layer 2 and 3.
- Maximum 8 devices can be daisy chained on an S/T bus.

### Layer 1

- Both B and D share layer 1, handles framing and defines reference points.
- 48 bit frames, 36 bits user data.
- Different frames (dependant direction traffic), uses TDM.
- Framing always occurs, even if no data on B channels.
- i.e. NT1 constantly provided clocking and framing  to the local exchange.



