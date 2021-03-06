Categories: solaris
Tags: dhcp
      dhcpd

### Server Configuration

- Run `/usr/sbin/dhcpconfig` as root.

        ***         DHCP Configuration              ***
        
        Would you like to:
                1) Configure DHCP Service
                2) Configure BOOTP Relay Agent
                3) Unconfigure DHCP or Relay Service
                4) Exit

- Type `1` to configure a DHCP service.
- If the DHCP service is currently running will be asked if you want to stop the DHCP service.

        Answer "Y" (recommended).

#### Process ####

##### 1. Configuring the DHCP database.

        ###     DHCP Service Configuration      ###
        ###     Configure DHCP data store and location  ###
        
        Enter data store (SUNWbinfiles, SUNWfiles or SUNWnisplus) [SUNWnisplus]:

-  `SUNWfiles` - Store the information on the server itself.
- `SUNWnisplus` - If the database is controlled by NIS+.
- If `SUNWfiles` selected, are then prompted for the location of the DHCP database.

      Enter full path to data location [/var/dhcp]:

##### 2. Initialise `dhcptab`.

        Enter default DHCP lease policy (in days) [3]:

- i.e. when the DHCP lease runs out, the DHCP client must renew the lease from the server.
- lowering the lease period enables the DHCP server to reclaim addresses with a greater frequency (useful for many temporary hosts).

      Do you want to allow clients to renegotiate their leases? ([Y]/N):

- Allows the client to ask the DHCP server for extended leases that are larger than the default lease time.
- Used to reduce the amount of traffic for clients that are active for extended periods.

##### 3. Configure the DHCP server options.

        Would you like to specify nondefault daemon options (Y/[N]): y
        Do you want to enable transaction logging? (Y/[N]): y
        Which syslog local facility [0-7] do you wish to log to? [0]: 0
        How long (in seconds) should the DHCP server keep outstanding OFFERs? [10]:

- How long a DHCPOFFER is good for.
  - If many clients or older (slower) clients, should increase the time to about 20 sec.

          How often (in minutes) should the DHCP server rescan the dhcptab? [Never]:

- Daemon will reread the configuration file when the server is restarted (but all leases will be lost).

          Do you want to enable BOOTP compatibility mode? (Y/[N]):

- Only use if using BOOTP protocol.

          Enable DHCP/BOOTP support of networks you select? ([Y]/N): y
          Configure BOOTP/DHCP on local LAN network: 192.168.1.0? ([Y]/N):y
          Enter starting IP address [192.168.1.0]: 192.168.1.50
          Enter the number of clients you want to add (x < 255): 10
          Disable (ping) verification of 192.168.1.0 address(es)? (Y/[N]):

- If someone statically assigns an IP address from your DHCP server address pool, will result in an IP address conflict.
    - Answering "Y" the server will assume that all of the IP address in the block that was specified are available to be given out to new clients.
    - Answering "N" will cause the server to first check if the IP address that is about to be issued is already in use (by pinging).

- Note, if `syslog` was enabled, must add the following line to `/etc/syslog.conf`:

              local0.notice                   /var/log/dhcpsvc


##### 4. Configuring DHCP for remote networks.

- DHCP can be configured to handle requests from across networks.

            Enter Network Address of remote network, or <RETURN> if finished:

- Enter the remote network address that you want to configure DHCP for.

            Do clients access this remote network via LAN or PPP connection? ([L]/P):

- If clients on the network use PPP to connect to the network answer with "P" else "L".

            Enter Network Address of remote network, or <RETURN> if finished:

  - etc


### Client Configuration ###

- e.g. for interface `hme0`.

1.  Create an empty `/etc/hostname.hme0`                       
  
        # > /etc/hostname.hme0

2.  Create an /etc/dhcp.hme0 file.
  - File can be empty if you want to accept the defaults, but may contain one or both of the following directives.

            wait <time>
            primary

  - where:

            wait      Default, ifconfig waits 20 sec for DHCP server to respond, after which
                      boot continues with interface configured in the background.
                      Specifying wait tells ifconfig not to return for <time>  until DHCP has responded.
                      Can specify special value "forever"
            primary   Indicates to ifconfig that interface is the primary interface.
                      i.e. if you have more than one interface with DHCP, one has to be the primary.