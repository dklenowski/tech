Categories: networking 
            cisco
Tags: debug
      router
      reverse telenet

### Miscellaneous Commands ###

#### `Router(config-line)# logging synchronous`

- Used when debugging and simultaneously trying to type commands.
- The command appears in full, even if router outputs to console.

#### `Router(config)# no ip domain-lookup`

- Turn off IP domain lookups.
- i.e. so when you type wrong command wont try to telnet.

#### `Router# reload`

- Router is restarted.

#### `Router# write erase`

- Remove startup configuration
- Running config is bare minimum.
- Note, all interfaces are shutdown.

### Using Debugging

- Disable all logging destinations except logging buffer, and clear the logging buffer.

        router# conf t
        router(config)# no logging console
        router(config)# no logging monitor
        router(config)# no logging <ip_address>
        router(config)# logging buffered 128000 debugging
        router# clear logging

- Start debugging session (should not last more than 3 - 5s).

        router# debug <command>

- To turn off debugging:

        router# undebug all

- To check your results:

        router# show logging

### Local Router Security

#### `Router(config-line)# login local`

- If configured in `line vty 0 4`
- Must specify a username / password pair when logging in router will check the local username / password database.
- Must use the username command (cant use the password command).

#### `Router(config-line)# password <password>`

- Alternative to the login local command.
- Router will prompt for the password.

#### `Router(config)# username username privilege [ 0 - 15 ] password { protection } password`

- privilege:
  -  0 - 15
  - 0 - lowest
  - 15 - full privileges

- protection:
  - optional
  - 0 - password recorded as plaintext
  - 7 - password hidden
  - Note, the username command is an alternative to the password command in any of the line configuration modes.


### Reverse Telnet Sessions

#### Switching between active sessions

- Escape from the current session using `ctrl-shift-6-x`.
- Display all open sessions using the `show sessions` command.
- Enter the session (conn) number displayed in the show sessions command to connect back to the corresponding device.
- To disconnect the session use the `disconnect [ connection ]` command.

#### Cabling

- Use a 68 pin connector and breakout cable.
- These octal cables provide 8 RJ-45 rolled cable async ports on each 68 pin connector.
- Connect each RJ-45 rolled cable async port to the console port of a device.

#### Process

1. Configure an ip address on the host with the octal cables that will be used for the reverse telnet connection.
  - Usually use the loopback 0 interface (since always up).
  - e.g.

            interface Loopback0
            ip address 172.21.1.1 255.0.0.0

2. Configure the lines that the octal cables will use (will be lines in the config)
  - e.g.

            line 65 80               // this will be displayed, i.e. auto detected
              session-timeout 20     // session timeouts after 20 min of inactivity
              no exec                // unwanted signals from the attached device
                                     // will not launch an exec process on the terminal
                                     // server (i.e. this router)
              exec-timeout 0 0       // disable exec process started on this terminal
                                     // server
              transport input all    // allow all protocols (e.g. telnet, ftp) to use
                                     // this line

3. Can either use the telnet command or configure IP hosts (shortcut)
  - For telnet command:

              TerminalServer# telnet ip_address port
              
              ip_address      the IP address configured in step 1
              port            is 2000 + line_number
                              Use the show line command to see available line
                              e.g. for line 65 port = 2065

  - For IP host command:

              TerminalServer(config)# ip host name port_number ip_address
              
              name            symbolic name for the host
              ip_address      the IP address configured in step 1
              port            2000 + line_number

  - Then use the telnet command:

              TerminalServer# telnet host_name
              
              host_name           the symbolic name configured using ip host command

#### Troubleshooting ####

- Port address configured correctly?
- Address used for reverse telnet up/up (therefore should use loopback)?
- Test direct connectivity by telnetting?
- If disconnected, check timeouts?