Categories: networking
Tags: dhcp
      renew

## Note

- See [RFC2131](http://www.faqs.org/rfcs/rfc2131.html)
- Extension of the `bootp` protocol (RFC951)

## DHCP transition states

### 1. initialising

- Client starts with IP address 0.0.0.0.
- Sends out a DHCP discover packet on the local subnet.
- Broadcasts on UDP port 67.

### 2. selecting

- Checks if valid free address and responds with DHCP offer packet containing.
- IP address, subnet mask, IP address of DHCP server , lease duration, other configuration options.
- Broadcasts on UDP port 68.

### 3. requesting

- For > 1 DHCP server, client selects the first to arrive and responds with DHCP request directly to server it will use as DHCP server.

### 4. binding

- Server responds to client with DHCP acknowledgement packet.

### 5. renewing

- When lease 50% over, client tries to renew lease.
- Sends DHCP request directly to its DHCP server.
- Server normally responds with DHCP acknowledgement.

### 6. rebinding

- At approximately 87.5% of lease expiration, client attempts again to renew lease.
- This only happens if lease wasn’t renewed in previous step.
- If fail,  client tries to contact any DHCP server.