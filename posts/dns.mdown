Categories: networking
Tags: dns
      nameserver
      zone

## Terms ##

### Domain Name

- Identifies host position in domain namespace (i.e. index to DNS distributed database).
- Consists of labels separated by a "." delimiter.
- NB Domain names are not case sensitive.
- Labels:
  - Max 63 characters.
  - Can be alphabetic characters, numerics and hyphen.

#### Fully Qualified Domain Name (FQDN)

- aka absolute domain name.
- Written relative to the root node, i.e. ends with a "."
- FQDN must not exceed 255 characters.

#### Domain Name alias

- aka Relative Domain Name (RDN)
- Pointer from one domain name (alias) to the official domain name.

### Zone

- Encompasses a domain of the same name and all existent domains beneath it that have not been delegated away.
- Once a domain is delegated away (i.e. has its own SOA and NS records) and is managed by a different server, it forms a new zone of authority distinct from the parent server.
- i.e. Each zone has 1 primary name server (loads contents of zone from local file) and >= 1 secondary servers.

### Inverse Queries

- A search for the domain name based on IP address (indexes a given datum).
- Processed solely by the nameserver receiving the query.
- Name server searches local data and returns the domain name.
- Implementation of inverse queries is optional according to the DNS specification.

## Name Server

- Stores information about the domain name space.
- Contains complete information about a zone (is "authoritative" for that zone).
- Name server then becomes authoritative for that zone.
- When delegating sub domains (i.e. zone) must include pointers to the name servers that are authoritative for that subdomain.
- Types of name servers:

### 1. Primary Name Servers

- aka Primary server.
- Reads data for zone from a local file.

### 2. Secondary Master Server

- aka Slave server.
- Gets data for zone from a server that is authoritative for that zone (called its master server).
- NB Master server for slave not necessarily zones master server (i.e. can be another secondary server), can be used for load balancing.

### 3. Cache Only Servers                        

- Cache DNS information until the data expires (occurs on all servers).
- Is not authoritative for any zone.
- Issues requests to authoritative servers.

### 4. Root Name Server

- Know authoritative name servers for each of the top level domains.
- NB Most root name servers authoritative fro the generic top level domains e.g. .edu, .com
- Given any query, root name servers can at least provide the address/ name of the name servers that are authoritative for the top level domain name.

### 5. Forwarding Servers            

- Master, slave or caching only server that forwards all its questions to a specific and predetermined external DNS server.
- Often used for security reasons.

### Notes:

- Both the primary master and slave name servers for the zone are authoritative for that zone.
- Possible for a name server to be authoritative for more than 1 zone (a server is called a primary master if it is a primary master for most of the zones it loads).

### Caching

- Name servers (both primary and secondary) cache all query responses for future reference.
- Use a TTL configured on the name server to specify the time allowed to cache the data.

### Data Files

- aka zone data files/ db files
- Files which the primary uses to load the zone data.
- Slave servers can also load the zone data from files (e.g. for backups).

### Resolution          

- Namespace structured as inverted tree, nameserver requires domain name and addresses of root name servers to find its way to any point in the tree.
- 2 type of queries:

#### a. Recursive

1. Resolver sends recursive query to a name server for a particular domain.
2. Queried name server checks if it is authoritative for the data requested.
  - Queried name server obliged to respond with the requested data (cannot refer query to another name server).
3. If queried name server is not authoritative for the data, queried server queries other name servers (closest known name server where closest are name servers authoritative for the zone closest to the domain name being looked up).
  - The name server that receives the recursive query sends the same query (no modifications) when probing other name servers.

#### b. Iterative

- Name server responds to the querier with the best answer it knows.
- No additional querying is required, name server consults only local data.

## DNS (Bind) Configuration

- DNS lookups are case insensitive, therefore bind database files case insensitive (although lookups case insensitive case is preserved).
- Resource Records must start in column 1.
- Comments start with a semicolon `;` and end at the end of the line.
  - Note, since bind Version 8, `//`, `/*..*/` and `#` can also be used for comments.


### `/etc/named.conf`

- Main configuration file.
- Lists the zones that the DNS server supports.
- Points to the zone database files (one for each zone supported) which contain:
  - Host names and IP addresses
  - Mail server information (e.g. `MX` records)
  - Host name aliases (`CNAME` records).

### `named.conf` directives

#### `acl`

- Access Control Lists.
- Each ACL can be used in the `zone` statement or in the global options statement.
- Can use CIDR notation for netmasks.
- e.g.

        // create ACL called internal
        acl "internal" { 194.168.85/24; };

- Can now use in the `options` statement:

        options {
          directory "/var/named";
          allow-transfer { internal; };
        };

- The above statement we allow any DNS slave in the network 194.168.85.0 to zone transfer (synchronise) with us.
- The above statement can be overridden for individual zones.


#### `options`

- Required, sets the default main parameters for all zones defined in the file.


        options {
          directory "/var/named";
          allow-transfer { 192.168.1.1 ; };
          forwarders { 192.168.1.2 ; };
          forward only;
        };

#### `directory`

- Location of the zone resource files.

##### `allow-transfer`

- Determines which slaves may zone transfer from this server (i.e. for synchronisation).

##### `forwarders`

- Create a forward only server (will still be able to query other servers unless the forward-only option is used).

##### `forward only`

- Tells the DNS server to forward all zone lookups other than lookups to zones that the server supports.

##### `server`

- Optional, used to define a remote DNS that is "bogus" and giving out bad data.
- DNS server will not send queries to this server.

        server 62.254.198.1 {
          bogus yes;
        };

#### `zone`

- Specify the zones of this server.
- 4 types of zone entries:

##### `hint`

- Points to the local file that list the current root-level servers.
- e.g. `/var/named/named.root` (from `ftp.rs.internic.net`).
- Used to prime DNS server memory based named cache and provide hints on the root-level name servers.
- e.g.

        // file containing the root name servers
        zone "." in {
               type hint;
               file "named.root";
        }

##### `master`

- Points to a local file that contains the zone information for the supported domain.
- There are 2 types of zone definitions:

###### Forward Zone

- Maps host names to IP addresses.

        zone "gvon.com" in  {
               type master;
               file "g/db.gvon.com";      // file where authoritative zone info held
                                          // file in location /var/named/g/db.gvon.com
        };

###### Reverse Zone

- Used to map IP address to hostname.

        zone "85.168.194.in-addr-arpa in {
               type master;
               file "networks/db.194.168.85";
        };

- Must reverse then network address  (194.168.85.0 --> 85.168.194) and append the top level domain `in-addr.arpa`.
- All DNS reverse zone information is stored under the official top level domain zone called `in-addr` (for internet address) and a subdomain of `arpa` which is used solely for reverse zones.

##### `slave`

- Used to specify that the server is a slave for a particular zone and must contact the master server for zone data.
- The server will automatically acquire the zone data (once in.named started) and dump it to the specified file.
- All subdirectories of the filename must exist.

        zone "domainbank.co.uk" in   {
               type slave;
               masters { 194.168.85.105;  };
               file "secondary/d/db.domainbank.co.uk";  // directory /var/named/secondary/d must exist
                                                        // useful to break domains based on first letter
        };

##### `stub`

- Used to delegate away authority for a given zone to another DNS server (in effect creating a new zone of authority).

        zone "support.gvon.com" in {
               type stub;
               masters { 194.168.85.2; };
               file "stubs/db.support.gvon.com";
        };

- In above example, we are master for the domain `gvon.com` and are delegating the subdomain `support` to master server `194.168.85.2`, in effect creating a new zone of authority called `support.gvon.com`.
- As we acquire information about this zone from the master to which we have now delegated authority, we will store the information in a file called `/var/named/stubs/db/db.support.gvon.com`.

## Resource Record (RR) Format

- The zone database files (resource record files) are in RR format.
- Each file holds zone (domain) information for a specific zone.
- The zone line defines the zone in double quotes (e.g. `gvon.com`).
- In the zone database file itself, may refer to the zone by using the meta-character `@` which is called the current origin.
- e.g.For the zone `gvon.com` (in the `named.conf` file) we can use the meta-character `@` in the zone database file to refer to `gvon.com`.
- Syntax:

        [name]    [ttl]       [class]       [record-type]       [record-data]

- Order:

        SOA
        NS
        Other     A
                  PTR
                  CNAME



 


