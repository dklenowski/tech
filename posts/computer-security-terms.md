Categories: computing
            security
Tags: computer security
      security

## Objectives

1. Confidentiality
2. Integrity
3. Availability
4. Authorised Use


## Security Services

1. Authentication

  - Confirm users identity.
  - e.g. password.
  - Authentication accomplished using passwords, smart cards, biometrics etc
  - Once authentication established, access to user (or generally principle) is governed by access control mechanisms.
  - Types of Authentication:
        - Entity Authentication	
          - Authenticates identity based on remote communicating party.
        - Data Origin Authentication	
          - Authenticates claimed identity of originator if message.
  - Authentication Mechanisms:
      - Kerberos
      - PKI

2. Access Control Services
  
  - Prevents unauthorised use, disclosure, modification, destruction or invocation of operations.

2. Confidentially          

  - Protecting data from unauthorised use / users.
  - i.e. only intended recipient of a message can make sense of it.
  - Confidentially accomplished using Cryptography.

3. Integrity

  - Ensure message had not been tampered with.
  - Use signature schemes for integrity.

4. Nonrepudiation          

  - Provides undeniable evidence of actions such as proof of origin of data or receipt of data to sender.
  - Use signature schemes for nonrepudiation.
  
## Algorithms

### One Way Hash Function    

- Operates on arbitrary length message H(M) and returns a hash value h of fixed length m.

        h = H(M)      where h has length m

- Properties:          
  - Given M, easy to compute h.
  - Given h, hard to compute M such that H(M) = h
  - Given M, hard to find a message M' such that H(M) = H(M')

- Used in digital signatures.
- Examples:
  - MD4, MD5 (produce a 128 bit hash)
  - SHA (designed by NIST) produces 160 bit hash used in the digital signature algorithm (DSA).

### Message Authentication Codes (MAC)

- One way hash functions that use a key.
- Used to as an integrity check e.g. to authenticate files, to authenticate messages between users.
- HMAC - Keyed Hashing For Message Authentication.

### Symmetric Ciphers

-  Identical key for both encryption and decryption.
- Faster than asymmetric ciphers.
- Alternative hybrid cryptosystem.
  - Private key for the session (session key) established using public keys.
- Further subdivided into:
  1. stream ciphers - Operate on a stream of bits.
  2. block ciphers - Operate of a group of bits (a block).
- e.g. DES, Triple DES (3DES), AES, IDEA, BlowFish, CAST 

### Asymmetric Ciphers      

- Use different keys for encryption and decryption.
- i.e.          

        E{K1}(M) = C   Where K1 is encryption key.
        D{K2}(C) = M   Where K2 is the decryption key.

- e.g. RSA

### Digital Signatures      

- Provide proof of authenticity and integrity of the message.
- Also used for nonrepudiation.
- Basic digital signature protocol:
  1. Sender encrypts document with his private key (aka signing document)
  2. Sender sends message
  3. Receiver decrypts document with senders public key (verify signature).

- Signing large documents time consuming, so generally only sign a hash of the message.
- The one way hash algorithm and digital signature algorithm agreed prior.
- Digital Fingerprint
  - Message hash that is encrypted.
  - i.e. represent original message in a unique manner.

- Using digital signatures with hashes does not guarantee confidentially of message, therefore usually encrypt message with receivers public key.
- Algorithms:
  - Elgammel      
    - Can be used for digital signatures and encryption.
  - RSA 
    - Can be used for digital signatures and encryption.
  - DSA           
    - Digital Signature Algorithm
    - Can only be used for digital signatures.
    - Part of the Digital Signature Standard (DSS).
    - Similar to RSA, in that system generate a digest of the message to be encrypted. The only real difference is that DSA's verification process is more resource intensive than RSA.

#### Key Management

- Life cycle of key involves
  1. Key Establishment
    - Key generation and distribution for symmetric keys usually involves key transport or key agreement.
  2. Ket Backup/Recovery or key escrow (where applicable)
    - Key escrow, used when law enforcement wants keys, reflects the fact that keys typically need to be held in trust by a third party.
  3. Key Replacement/Update 
    - aka rekeying
    - Used when keys expire, need to be updated.
  4. Key Revocation
  5. Key Expiration/Termination
    - May involve key destruction / key archiving.

##### RSA Key Transport

- Used for key establishment for symmetric encryption.
- e.g. for email using symmetric keys (since symmetric cryptosystems faster than public key cryptosystems).


        Originator                      Transmitted Message                         Recipient

        plaintext ------> Symmetric -------> Encrypted -------> Symmetric --------> Plaintext
        message           Cryptosystem En     Content           Cryptosystem Dn     Content
                              /\                                           /\
          Symmetric Key (K)  -|----> RSA En ----> Encrypted ----> RSA Dn --| Symmetric Key (K)
                                      /\          Key               /\
                                      |                             |
                                      Recipient                     Recipient
                                      Public Key                    Private Key

Process:

1. Message originates generates random symmetric key K, encrypts message using that key and attaches a copy of the symmetric key encrypted under the public key of the intended recipient.
2. Recipient that holds correct RSA private key decrypts the RSA encrypted symmetric key and uses that key to decrypt the message content.

### Digital Certificates            

- Verifies a public key being used corresponds to a private key (i.e. provides authentication services).
- Digital signatures depend on the integrity of the public keys (i.e. how can verification be done on a public key to make sure it did not come from an impostor).
- A mutually trusted third party is used, called a Certificate Authority (CA).
- CA usually contains information about user e.g. public keys, expiry date etc
- The issuer signs the certificate with its private key.
- The implicitly assumption in process is that the CA's public key is widely available and genuine.
- Public key certificates based on the X.509 standard.
- Certificate information contains:
  - Subject
    - Identifying information.
  - Issuer
    - Identification and signature of the Certificate Authority.
  - Administration Info
    - Administrative information for the CA's use.
  - Distinguished Name (DN)
    - Provides an identity in a specify context.
    - DNs defined by the X.509 standard (while defines the fields, field names and abbreviations used to refer to the fields).
- X.509 standard for DN's

          Field                     Abbreviation        Description                   e.g.
          Common Name               CN                  Name being certified          CN=Frederick Hirsch
          Organisation or Company   O                   Name is associated with this 
                                                        organisation.                 O=The Open Group
          Organisational Unit       OU                  Name is associated with this
                                                        organisation unit.
                                                        e.g. a department             OU=Research Institute
          City / Locality           L                   Name is located in this City  L=Cambridge
          State/ Province           SP                  Name is located in this 
                                                        State/Province                SP=Massachusetts
          Country                   C                   Name is located in this	
                                                        Country (ISO Code).           C=US

- Note, the CA may define a policy for specifying which DN field names are optional and which are required. It may also place requirements upon the field contents.

### SSL/TLS

- SSL developed by Netscape.
- IETF developed TLS specification (uses SSL with some minor modifications).
- Can be used to protocol any protocol that operates over TCP (e.g. telnet, ftp, web etc)
- i.e. encrypts at the transport layer.
- Can provide:
  1. Server Authentication
    - Server authenticated to client by demonstrating possession of a particular private key.
  2. Confidentially
    - Data items transferred are encrypted.
  3. Integrity
    - Data items transferred are protected with a MAC.
  4. Client Authentication
    - (optional) Authenticates client to server by demonstrating possession of a particular private key.

#### Process

1. Server sends its public key to the client in the form of a certificate.
  - Certificate is signed by a CA whose own public key is a priory known to and trusted by the client.
  - Client has confidence that it has received the correct server public key.
2. Client generates a random master secret and sends to server, encrypted with the servers public key.
3. Master secret used to generate symmetric En keys for confidentially and MAC keys for Integrity services.
  - Because of the correct server can decrypt the master secret and thus the  encrypted data from the client, the server is implicitly authenticated to the  client.

#### Client authentication
- Optional, additional feature.
- Depends on the use of a client based key pair and a certificate for that key pair that is issued by a CA.

1. Client uses its private key to generate a digital signature on a fresh data item (i.e. item unique to TLS/SSL session to prevent replay attacks) and sends this signed data item along with its certificate to the server.
2. Server verifies digital signature and uses the certificate to check that the correct client public key has been supplied.
  - Has the effect of authenticating the client to the server.

#### Internals ####

- Internally SSL/TLS consists of 2 protocols
1. Record Protocol
  - Defines the basic format for all data items sent in the session.
  - Provides for compressing data, generating a MAC on the data, encrypting data and ensuring the receiver can determine the correct data length (given that data may need to be padded).
  - MAC is prefixed to the data as part of the Record Protocol prior to encryption.
  - A record sequence number is included to protect agains reordering of data items.

2. Handshake Protocol
  - Used to negotiate which protection algorithms are used to authenticate the client and server to each other, to transmit the required public key certificates and to establish session keys for use in the integrity check and encryption processes of the Record Protocol.
  - Different key establishment protocols are supported i.e. RSA key transport, Diffie-Hellman etc
  - When a new session is established, may be possible to reuse existing session keys from  prior communication.
  - Session keys have an associated session identifier for this purpose.
  - This has the advantage of reducing overhead. 

Notes:

  - The Handshake protocol is conveyed via the Record Protocol.
    - In the first couple of messages the Record Protocol cannot encrypt or compute integrity checks because the keys are not known yet, however protocol is designed in such a way that this does not present a security problem.
  - Session keys --> Symmetric key encryption keys and MAC keys.


## Security Standards

- IPSec                
  - IP Security
  - Crypto based on the security at the IP layer.
  - Algorithms: DES, 3DES, DH, MD5, RSA, SHA-1
- OpenPGP              
  - Open Pretty Good Privacy
  - Security services for email and data files.
  - Algorithms: DES, 3DES, DH, MD5, RSA, SHA-1
- PPTP                 
  - Point to Point Tunnelling Protocol
  - Used to create VPNs
  - Algorithms: DES, RSA
- SET                  
  - Secure Electronic Transaction
  - Secure credit card transactions.
  - Algorithms: DES, HMAC-SHA1, RSA, SHA1
- S/MIME               
  - Security at the application layer.
  - Algorithms: DES, 3DES, MD5, RSA, SHA1
- SecSh                
  - Secure Shell
  - Secure Remote Access
  - Algorithms: DES, 3DES, RSA
- SSL                  
  - Secure Sockets Layer and TLS (Transport Layer Security)
  - Secure Pipe at the Application Layer
  - Algorithms: DES, DH, RSA, SHA1