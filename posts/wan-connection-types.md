Categories: networking
Tags: wan
      connection
      packet
      circuit


## Dedicated / Leased Lines

- Point to point dedicated links usually CSU/DSU between routers at each end
- Typical layer 2 protocols: PPP, HDLC, SLIP
- Typical connections: synchronous serial
- Usually synchronous serial connections (Cisco supports EIA/TIA- 232, EIA/TIA- 449, V.35, X.21, X.25, EIA- 530 )
- Advantage: Cost effective over short distance
- Disadvantage: More costly since line not shared

## Circuit Switched

- Dedicated physical circuit through carrier network
- Requires call setup and teardown
- Typical layer 2 protocols: PPP, SLIP
- Typical connections: asynchronous serial
- e.g. ISDN PRI/BRI
  - Asynchronous circuit switched connection
  - Modem based (minimal cost)
  - Usually configured using DDR (i.e. backup)
  - Uses asynchronous serial interface:
    - EIA/TIA-232 - Interface to external modem
    - RJ-45 (Australia) - Interface to telephone

## Packet Switched

- Network devices share single point to point link to transport packets across the carrier network
- Uses virtual circuits (VCs) that provide end to end connectivity
- Usually use synchronous serial connections (same standards as dedicated serial connections)
- Typical layer 2 protocols: X.25, Frame Relay
- Advantage: WAN speeds comparable to leased lines with lower cost
- Advantage: Cost effective for sites over large geographic areas