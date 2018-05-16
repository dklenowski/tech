Categories: monitoring
Tags: snmp
      mib

## Versions ##

### SNMP v1
- Request/response protocol.
- All SNMP MIB objects (SMI v1 and SMI v2) can be used.
- Limited security.

### SNMP v2
- Not backward compatible with SNMP v1.
- Most of the enhancements are to the SMI specification (e.g. information modules which are used to group related definitions).
- SNMP v2p - Party based security.
- SNMP v2c - Community based security.

### SNMP v3 ###
- Utilises a User Based Security Model (USM) which provides support for secure authorisation and packet encryption.
- Note, provides support for SNMPv1 community strings.

## SNMP Operations ##

- SNMP v1 defines 5 protocol operations (get, get-response, get-next,set-request and trap)
- SNMP v2 (and SNMP v3) add get-bulk, inform and redefined trap packet format.

### get ###

- Request for agent to return >= 1 objects.
- Can request as many objects as will fit into single packet (484 bytes).

### get-response ###

- Agent sends in response to get, get-next or get-bulk.
- Used to acknowledge packet sent from SNMP Manager.

### get-next ###

- SNMP Manager request the next object/s in the MIB supported by the agent.
- For each object, agent returns the object that is next in the MIB tree in lexicographical order (i.e. the next greater OID).
- e.g. used when SNMP Manager doesn't know the mIB that is on the agent or the instances of all objects.
- e.g. snmpwalk

### set-request ###

- Similar to the get operation, except manager fills in the desired values for the objects and the agent is requested to change the value of these objects.
- Agent sends back get-response packet with the new values and the status of the set-request.
- The agent will not allow a set-request unless the manager has write access.

### get-bulk ###

- Improves performance of get requests.
- i.e. allows agent to fit as many values as possible in each get response packet (but not exceeding the maximum SNMP packet size).

### inform ###

- Allow agent to keep track of notifications (trap's) sent to each recipient and receive acknowledgements of the receipt of these notifications.
- Agent can resend notifications (trap's) if acknowledgement is not received.
- e.g. Typical reason's event notification not received by SNMP manager.
    - Agent was reinitialised.
    - Agent ran out of space to save informs and had to drop.
    - Agent suppressed certain certifications.
    - Network dropped / lost notification packet several times.
    - No network connectivity between agent and NMS.

## SNMP Trap's ##

- Allows agent to asynchronously send notifications that an event has occurred.
- Uses best effort delivery (therefore no acknowledgement).
- trap identifier (traptype) - Specify which trap this operation is for.
- For SNMP v1

    - Generic trap's (traptype values 0-5)
 
      0       cold reboot (device back online after reboot)
      1       warm boot (also reboot but also generated if SNMP process restarted)
      2       link down
      3       link up
      4       authentication failure (attempt to poll SNMP agent on device
              has used the wrong community string)
      5       EGP neighbour loss (rarely used)

    - Specific Trap's (typetype 6)
        - aka enterprise specific trap.
        - Trap subtype to further distinguish enterprise specific trap's (NB for generic trap's, the trap subtype is 0).
        - Enterprise field usually populated with a specific OID.

- For SNMP v2

    - Redefined the trap PDU, making the same format as the rest of the SNMP PDU.
    - Combined the enterprise, generic trap and specific trap fields into a varbind (snmpTrapOID.0) which contains a single OID that specifies what the trap is.

### Trap Identification ###

- For enterprise specific trap's.
- Traps identified by trapSubtype, trapOID and variable data information.
- e.g. 
    - Empire
        - uses the trapOID as an enterprise identifier.
        - trapOID .1.3.6.1.4.1.546.1.1 indicates an Empire trap.
        - i.e. all empire traps use this trapOID.
        - rely on the trapSubtype to define the specific trap.
    - Cisco
      - Use a mixture of all trap implementations.
      - 2 most common Cisco traps formats are defined:
          1. using a separate trapOID for a specific type of trap and defined further using a trapSubtype.
          2. using a trapOID as a device identifier (i.e. identifies the specific model of Cisco hardware) and further defined using the trapSubtype or variable data.

- e.g. ASN.1 extract for the processStopTrap enterprise trap as defined in the empire.asn1 mib file

          processStopTrap TRAP-TYPE
                  ENTERPRISE sysmgmt
                  VARIABLES { pmonIndex, pmonDescr, pmonAttribute,            // 9 variables sent in trap
                              pmonCurrVal, pmonOperator, pmonValue,           // all have OID's defined in
                              pmonFlags, pmonRegExpr, pmonCurrentPID }        // the empire MIB
                  DESCRIPTION
                     "This Trap is sent when using a Process Monitor
                      Table entry to monitor the state of a process.
                      When the processing being monitored dies or
                      transitions into a Zombie (or not runnable state),
                      this Trap is sent.  This Trap is sent if the value
                      of pmonFlags does not preclude sending Traps."
                  ::= 10                                                      // value for trapSubtype


## MIB ##

- Management Information Base
- Specifies data items host must keep and the operations allowed on each.
- e.g. MIB specification specifies IP software must keep a count of all octets that arrive over the network interface and specifies the network management software can only read these values.

### MIB II ###

- Standard TCP/IP MIB.
- MIB II variables stored as counters (therefore must take 2 values and calculate the delta).
- Divides network management information into 8 categories.
    - System - Host OS.
    - Interfaces - Individual network interfaces.
    - Address Translation - e.g. ARP mappings.
    - IP - Internet protocol software.
    - ICMP - ICMP software.
    - TCP - TCP software.
    - UDP - UDP Software.
    - EGP - Exterior Gateway Protocol software.


### MIB Variables

- Actual management data stored on the node (e.g. single int value).
- Software in agent responsible for mapping between MIB variables and data structures on device.

### Object Identifier (OID) 

- Uniquely names MIB object.
- Sequence of integers that traverse a global tree.
- OID Name 
    - Textural name for object.
- OID Descriptor 
    - Dotted number notation of the OID.
    - A fully qualified OID is guaranteed to be unique.

### MIB Objects 

- Each MIB object controls one specific function.
- Either:
    - Scalar Object - Defines a single object instance.
    - Tabular Object - Defines multiple related objects that are grouped into tables.
- Formal descriptions and structure of objects defined using ASN.1 notation described below.
- e.g. MIB Object

        tpTDMIfCollectTimeInterval OBJECT-TYPE
                      SYNTAX        Counter32
                      MAX-ACCESS    read-only
                      STATUS        current
                      DESCRIPTION   This object shows measurement time
                                    interval seconds
                                    :: = { tpTDMIfStatTableEntry 1 }


#### OBJECT

- Textual name (OBJECT DESCRIPTOR) along with corresponding OBJECT IDENTIFIER (OID).

#### SYNTAX

- Used to define the structure corresponding to the object types.
- i.e. the encoding of the object (how instances of that type are represented using the objects type SYNTAX).
- ASN.1 constructs used to define this structure.
- Offers different syntaxes which may be used, namely:
    - Primitive
        - INTEGER, OCTET STRING, OBJECT IDENTIFIER, NULL
    - Sequence
        - Used to generate lists of tables.
        - For lists
        
              SEQUENCE { [type1], ..., [type2] }
        - For tables

              SEQUENCE of [type]
    - Defined types
        - IP Address
            - OCTET STRING of length 4 in network byte order.
        - Counter
            - Non negative integer.
            - Monotomically increases until it reaches a maximum values and wraps.
        - Gauge
            - Non negative integer.
            - Max increases/decrease but has a maximum value.
        - Timeticks
            - Non negative integer.
            - Epoch time.
        - Opaque

#### DEFINITION

- Textural description of the managed object.

#### ACCESS

- One of: read-only, read-write, write-only, not-accessible, read-create, accessible-for-notify-indicators.

#### STATUS

- One of: mandatory, optional, obsolete, deprecated

## SMI ##

- Set of rules to define and identify MIB variables.
- i.e. rules for naming and defining variables.
- e.g. SMI standard includes definition of IPaddress defining it to be a 4 octet string.
- Also contains specification for the MIB tree, arranged hierarchically using OID's
- e.g.
    
    iso=1,org=3,dod=6,internet=1,mgmt=2,mib-2=1

- 2 versions (SMI v1 and SMI v2), v2 objects can be used in any version of SNMP (with the exception of 64 bit objects).
- SNMP v1 SMI specifies:
    - All managed objects haver certain subset of ASN.1 data types, e.g.
        - name - OID
        - syntax - Data types (e.g. integer, string)
        - encoding - How data is transmitted over the network.
    - The data types, which are primarily divided into:
        - Simple Data Types - Unique values (e.g. integers, octet strings, OID's)
        - Application Wide Data Types - e.g. network address, counters, gauges, time ticks etc

## ISO ASN.1 ##

- Abstract Syntax Notation 1
- SMI standard specifies all MIB variables mus be defined and referenced using ASN.1 notation.
- ASN.1 defines:

    - Formats of PDU's that are exchanged by SNMP entities.
    - Formal notation for the names and types of variables in the MIB
- ASN.1 provides:

    - Human readable notation for documentation (E.g. exact form and range of values).
    - Compact encoded representation for information that traverses the network.

- e.g. Using ASN.1 notation the `ipAddrTable` can be defined as:

     ipAddrTable ::= SEQUENCE OF IpAddrEntry



