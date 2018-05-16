Categories: networking
            cisco
Tags: catos
      switch
      vtp
      stp

## Notes ##

### IOS Based Switches ###

- e.g. 1900, 3500
- The catalyst 1900 are both menu driven and CLI driven (use the option “K” to enter CLI mode)
- CLI is only available on switches that running Enterprise Edition of Cisco’s IOS.

### Set Based Switches ###

- e.g. 6500, 6000, 5500

## Initial Configuration

### Hostname

        [IOS]   Switch(config)# hostname <name>
                <name>    1 - 255 alphanumeric characters
        [Set]   Switch (enable)  set prompt <name>


### Password                              

#### IOS ####

- Must configure both enable and user password before passwords will kick in.
- Do an exit from console to make the passwords active.
- Passwords are not case sensitive.
- defaults to `enable secret`

        Switch(config)# enable password level 1 <password>
        <password>         user password

        Switch(config)# enable password level 15 <password>
        <password>         full privileges

#### Set

        Switch (enable)  set password <password>
        Switch (enable) set enablepass

### Admin IP address                

#### IOS ####

        [Cisco 1900]    Switch(config)# ip address <ip_address> <netmask>
                        <ip_address>    the subnet portion must match the management VLAN 1
        
        [Cisco 3500]    Switch(config)# interface vlan 1
                        Switch(config-if)# ip address <ip_address> <netmask>

- To verify:

        Switch# show interface vlan 1

#### Set ####

- Assign IP address to VLAN (Default VLAN 1).

        Switch (enable)  set interface sc0 <ip_address> <netmask> <broadcast_address>
        Switch (enable)  set interface sc0 vlan


### Interface Configuration

#### Interface Description

##### IOS #####

        Switch(config-if)# description "<description>"

##### Set

        Switch (enable) set port name <mod/number> <description>

#### Port speed

##### IOS

- On the Catalyst 1900/2800 the port speed is fixed i.e. either 10BaseT or 100BaseTX
-  For Cisco 3500:

        Switch(config-if)# speed [10 | 100 | auto]

##### Set

        Switch (enable) set port speed <mod/num> [10 | 100 | auto]

#### Duplex                                   

##### IOS

        Switch(config-if)# duplex [auto | full | full-flow-control | half]

- To verify:

        Switch# show interface <type> <number>

##### Set

        Switch (enable) set port duplex <mod/num> [full | half]

- To verify:

        Switch (enable)  show port mod/num 

#### Trunking

##### IOS

- For Cisco 3500:

        coreswitch(config-if)#switchport mode trunk
        coreswitch(config-if)#switchport trunk encapsulation [ isl | dot1q ]
        coreswitch(config-if)#switchport trunk allowed vlan all

- To verify:

        coreswitch#sh int fa0/5 switchport
        
        Name: Fa0/5
        Switchport: Enabled
        Administrative mode: trunk
        Operational Mode: trunk
        Administrative Trunking Encapsulation: isl
        Operational Trunking Encapsulation: isl
        Negotiation of Trunking: Disabled
        Access Mode VLAN: 0 ((Inactive))
        Trunking Native Mode VLAN: 1 (default)
        Trunking VLANs Enabled: ALL
        Trunking VLANs Active: 1
        Pruning VLANs Enabled: 2-1001
        
        Priority for untagged frames: 0
        Override vlan tag priority: FALSE
        Voice VLAN: none
        Appliance trust: none

##### Set

      Switch (enable)  set trunk <mod/port> [ on | off |desirable | auto | negotiate ] <vlan/range> [ isl | dot1q | dot10 | lane | negotiate ]
      on            Permanent trunking, must also specify encapsulation.
                    Must configure trunking on other end.
      off           Permanent non trunking port.
      desirable     Attempts to convert the link to a trunk link.
                    If neighboring port on, desirable, auto.
      auto          Port willing to convert to trunk link.
                    Default fast / gigabit ethernet
                    Note, if both ports set to auto will not become
                    trunk link because neither side will ask to convert.
      negotiate     Permanent trunking mode, prevents port generating DTP frames 
                    (manually configure neighboring port as trunk port).

- To verify:

        Switch (enable)  show trunk [ mod/port ] 

- To clear:
  - When you issue set trunk VLANs 1 – 1000 automatically transported. even if specify VLAN range.
  - Therefore clear all trunks from VLAN first before using set trunk command.

            Switch (enable)  clear trunk <mod/port> <vlan_range>


### STP Configuration

#### Initial ####

##### IOS

        [Cisco 1900] Switch(config)#  spantree <vlan_list>
        [Cisco 3500] Switch(config)#  spanning-tree <vlan_list>

- To verify:

        [Cisco 1900] Switch(config)#  show spantree  [ <vlan> ]
        [Cisco 2500] Switch(config)#  show spanning-tree [ <vlan> ]

##### Set #####

- Modifying Root Bridge Selection:
  - Root bridge should be close to center of network.
  - Usually distribution switch (i.e. closest to resources and connected to greatest number of VLANs).
  - i.e. To reduce the bridge priority to 8192.

            Switch (enable) set spantree root <vlans> [ dia <network_dia> ] [hello <hello_timer> ]

- To enable on every port (default is `all`)

        Switch (enable)  set spantree enable [all]

- To enable/disable on specific ports:

        Switch (enable) set spantree [ enable <mod/port> | disable <mod/port> ]

- To verify:

        Switch (enable)  show spantree [ vlan ]


##### Portfast  

- Enables port enter forwarding state immediately decreasing time for listening and learning states.
- NB use uplinkFast on other model switches.

        [Cisco 1900] Switch(config-if)#  spantree start-forwarding

##### UplinkFast

- Allows blocked port to begin forwarding immediately when switch detects.
- Failure of current forwarding link.
- Decreased convergence time and disruption.
- Conditions:
  - `uplinkfast` must be enabled.
  - Switch must have at least 1 blocked port.
  - Failure must be on root port.

###### IOS

- To configure `uplinkfast` on all VLANs:

        Switch(config)#  uplink-fast

- To verify:

        Switch(enable)  show uplink-fast

###### Set

- To configure all VLANs with `uplinkfast`:

        Switch(enable)  set spantree uplinkfast enable                                                               

- To verify:
                                               
        Switch(enable)  show spantree uplinkfast


### VTP Configuration

#### Catalyst 3500 (IOS based)

        Switch#  vlan database
        Switch (vlan)#  vtp domain domain_name
        Switch (vlan)#  vtp {server | client | transparent }
        Switch (vlan)#  vtp password passwd

- To verify:

        Switch# show vtp status

#### Catalyst 6500 / 6000 / 5500 (Set Based switch)

- Can issue below steps in 1 command, i.e.:

        Switch (enable) set vtp domain domain_name password passwd mode mode v2 enable

##### Manual Configuration

1.  Prepare switch:

        Switch (enable)  clear config all    // remove existing configuration
        Switch (enable)  reload              // power cycle to clear VTP NVRAM
                                             // (e.g. to remove configuration revision number)
        
  - Alternatively, can change the VTP mode to transparent and then change it back to server.

2.  Choose VTP version:

        Switch (enable) set vtp version enable    // either version 1 or 2 (not interoperable)

  - All switches in management domain must be configured with the same version number

3. Set VTP domain               

        Switch (enable) set vtp domain <domain_name> { password <passwd> }
        <domain_name>   Max 32 chars (case sensitive)
        <passwd>        Optional (secure mode), must be the same for all switches in VTP domain

  - Don’t have to configure domain if switch operating in transparent mode.

4. Choose VTP mode for switch

        Switch (enable) set vtp domain domain_name mode [ server | client | transparent ]
        server        first switch in management domain
                      require at least 1 server
        client        if other "servers" already configured
        transparent   switch not going to share VLAN information can locally create/delete/modify VLAN information

#### VTP Pruning

- Reduces unnecessary flooded traffic.
- Broadcast and unknown unicast packets on a VLAN are forwarded over a trunk link only if the switch on the receiving end of the trunk has ports in that VLAN.

##### Catalyst 3500 (IOS based)

- By default VTP pruning disabled on IOS based switches

        Switch#  vlan database
        Switch (vlan)#  vtp pruning

##### Catalyst 6500 / 6000 / 5500 (Set Based switch)

- If pruning enabled on server, pruning enabled for the entire management domain by default VTP pruning is disabled.

1. Enable pruning:

        Switch (enable)  set vtp pruning enable     // by default enables pruning on VLANS 2 - 1000
                                                    // VLAN1 never eligible for pruning

2. Clear prune list:

        Switch (enable) clear vtp pruneeligible <vlan_range>

  - Clear prune list first (because all VLANs initially pruned).

c. specify eligible VLANs (i.e. specify which VLANs to prune):
  
        Switch (enable) set vtp pruneeligible <vlan_range>

#### VTP troubleshooting

##### Catalyst 3500 (IOS based)

- Show the current VTP parameters for the  management domain:

        Switch# show vtp status                                                                                    

- Show VTP message and error counters:

        Switch# show vtp counters                                                                               
                 
##### Catalyst 6500 / 6000 / 5500 (Set Based switch)

- Show current VTP parameters for the management domain:

        Switch (enable) show vtp domain

- Note:
  - Also shows VTP pruning information
  - domain name - if blank ,domain NULL
  - local mode - either client, server, transparent
  - VTP version must match

- Show summary VTP advertisements sent /received, configuration errors etc:

        Switch (enable) show vtp statistics                                                                  

- Note:
  - config digest errors can indicate corruption of frame from a physical layer or security issue

- To reset the configuration revision number to 0:

        Switch (enable) set vtp domain <domain_name> 




### VLAN configuration

- VTP domain must be configured before setting up VLANs.
- Only VTP modes that allow creation VLANs are server or transparent mode (only modes authorised to accept `set vlan` and `clear vlan`).

1. Create the VLAN:
  - Minimum input is the VLAN number.
  - Optional input includes VLAN name, type etc.

            Switch (enable)  set vlan <vlan_num>  [ <name> <name> <etc> ] 

2. Assign ports to VLAN:
  - Used to map VLANs to ports
  - Default all Ethernet ports on VLAN1


            Switch (enable)  set vlan vlan_num  <mod/port_list>
            <port_list>  e.g. 2/1-10 (do not enter spaces between port numbers)

#### Troubleshooting / Verification

- Display VLAN configuration:

        Switch (enable)  show vlan                                                                                                

- Clearing a VLAN:

        Switch (enable)  clear vlan vlan_number                                                                         

- Ports kept assigned to previous VLAN, but inactive / disabled state.
- Must reassign ports to active VLAN before attached devices can communicate again.
- Take into account STP when deleting VLANs.
- If:
  - VTP server            
      - VLAN is removed from VTP management domain
  - VTP client
      - Cannot delete VLANs
  - VTP transparent   
      - Deletions and insertions have only local significance.

 
