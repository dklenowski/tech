Categories: security
Tags: ssh
      certificate
      key


## SSH

- Ref: SSH - Secure Login Connections Over the Internet Tatu Ylonen, SSH Communications Security Ltd, Finland (www.usenix.org)

## Introduction

- Secure login, file transfer, X11 and TCP/IP over untrusted networks.
- Uses:
  - cryptographic authentication
  - automatic session encryption
  - integrity protection
- RSA used for key exchange and authentication
- uses symmetric algorithms for encrypting transferred data e.g. IDEA, 3-DES
- Replacement for: rsh, rlogin, rcp, rdist, telnet
- Can provide:
  - host authentication
  - user authentication
  - privacy
  - integrity
- Common Threats
  - network monitoring
  - connection hijacking
  - routing spoofing
  - DNS spoofing
  - DoS attacks

## SSH Protocol

- Packet based binary protocol.
- Works on top of any transport (e.g. TCP/IP, SOCKS) that will pass binary data
- Uses:
  - authentication
  - key exchange
  - encryption - Uses IDEA-CFB, 3DES-CBC, RC4 to encrypt data. All data compressed using gzip before encryption.
  - integrity mechanism - Uses CRC32, HMAC-SHA for integrity protection

## Implementation

#### 1. Client opens connection to server (NB attacker may cause connection to go to another server

#### 2. Server sends public RSA host key and another public RSA “server” key.

- Client compares received host key agains own database.

#### 3. Client generates 256 bit random number and choose encryption algorithm.

- e.g. IDEA, 3DES
- Client encrypts random number (session key) with RSA using both host key and the server key and sends encrypted key to server.
- host key
  - Binds connection to desired server host
  - i.e only server can decrypt the session key normally 1024 bit RSA
- server key
  - Used to make decrypting recorded historic traffic impossible after the server key has been changed (usually every hour) in the event the host key becomes compromised.
  - Normally 768 bit RSA

#### 4. Server decrypts RSA encryptions and recovers session key both parties start using session key (until this point all traffic has been unencrypted at the packet level)

- Server sends encrypted confirmation to client
- Receipt of confirmation tells client that server was able to decrypt key at this point, server machine authenticated and transport level encryption and integrity protection are in use

#### 5. User authenticated to server

- Can happen in a number of ways.
- Dialog driven by client which sends requests to server.
- First request always declares username.
- Server responds to each with either “success” (no further authentication required) or “failure” (further authentication required)
- Currently supported authentication methods:
  - password authentication
    - Password transmitted over encrypted channel
  - Combination of traditional .rhosts/hosts.equiv authentication and RSA based host authentication
    - Server generates 256 bit challenge, encryption with clients public host key and sending challenge to host
    - Client decrypts challenge and computes MD5 of the challenge and other information that binds retuned value to particular session.
    - Client sends this value to the server, server compares received values.
  - Pure RSA authentication
    - Possession of particular private RSA key serves as authentication
    - Server has list of accepted public keys
    - Client request authentication by particular key and server responds with challenge similar to .rhosts RSA authentication
  - Support can also be included for new authentication methods
    - e.g. Security Dynamics SecurID cards etc

#### 6. After authentication successful, preparatory phase begins

- Client sends request and prepares for actual session
- e.g. requests include allocation of a pseudo-tty, X11 forwarding, TCP/IP forwarding etc
- After all other requests, client sends request to start shell / execute given command.

#### 7. During interactive session, both sides allowed to send packets asynchronously

X11 and TCP/IP Forwarding

- SSH can automatically forward the connection to the users X server over the secure channel.
- Forwarding works by creating a proxy X server at the remote machine by allocating the next available TCP/IP port number above 6001 (- these correspond to X display numbers for that the port corresponding to display n is 6000+n).
- SSH server then lists for connections on this port, forwards the connection request and any data over the secure channel and makes a - connection to the real X server from the SSH client.
- DISPLAY variable automatically set to point to the proper value.
- SSH automatically stores Xauthority data on the server.
  - Client generates a random MIT-MAGIC-COOKIE-1 authentication cookie, and sends this cookie to the server, which stores it in the .Xauthority.
  - When a connection is made, client verifies that the authority data matches the generated random data, and replaces it with the real data.
  - The motivation for sending a fake cookie is that old cookies left at the server are useless after logout (many users keep the same terminal open for months at a time, and may briefly log into dozens of machines during that time, it is important not to leave the cookies lying around all these servers)
- TCP/IP forwarding works similarly
  - Server listens for a socket on the desired port, forwards the request and data over the secure channel and makes the connection to the specified target port from the other side there is no authentication for forwarded TCP/IP connections

### Authentication Agent

- SSH supports using an authentication agent.
- Agent is a program that runs in the users local machine.
- Agent holds users private RSA keys.
- Never gives out private keys, by accepts authentication requests and gives
- back suitable answers.
- In unix, agent communicates with SSH using an open file handle that is inherited by all children of agent process (the agent is started - as a parent of the users shell)
- Other users cannot get access to the agent, even for root it is fairly difficult to send requests to a file descriptor held by some - process.
- Different mechanism used on other OSs.

## Cryptographic Methods

- Different encryption methods use varying amounts of the key
  - IDEA-CFB - Uses 128 bits
  - 3DES-CBC - Uses 168 bits
  - RC4 - Uses 128 bits per direction
  - DES-CBC - Uses 56 bits
  - Note: New SSH protocol will use IDEA-CBC

### RSA

- Used for host authentication and user authentication.
- Normally uses keys of 1024 bits.
- Server key changes every hour and is 768 bits by default.
- Server key is never saved on disk.

### Key exchange

- Performed by encrypting 256 bit session key twice using RSA.
- Server host authentication happens implicitly with the key exchange (idea that only the holder of the valid private key can decrypt the session key and receipt of the encrypted confirmation tells the client that the session key was successfully decrypted)

### client host authentication / RSA user authentication

- Done using challenge response exchange where response is MD5 of the decrypted challenge plus data that binds the result to a specific session (host key and anti-spoofing cookie)

### Integrity

- Transmitted data currently protected against modification by computing a CRC32 of all packet data (including random padding) before encryption Checksum and all packet data are encrypted.
- Other newer integrity mechanisms are HMAC-MD5 or HMAC-SHA

## Setting up DSA Keys

### Setup

#### Generate ssh key:

        # ssh-keygen -t dsa

- This will create 2 files:

        ~/.ssh/id_dsa.pub   public key
        ~/.ssh/id_dsa       private key

- Copy public key to the remote server:

        # scp ~/.ssh/id_dsa.pub jdoe@remotebox

- Install the key on the remote server:

        # cat id_dsa.pub ~/.ssh/authorized_keys2

### Implementation

- ssh jdoe@remotebox from the localbox
- ssh lets remotebox’s sshd know that we want to use DSA
- remotebox sshd generates a random number, encrypts it using the public key
- remotebox sends encrypted random key back to localbox
- ssh on localbox decrypts it (using the private key), encrypts it again and sends it back to remotebox