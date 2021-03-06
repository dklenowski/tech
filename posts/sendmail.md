Categories: linux
            unix
Tags: sendmail

## Troubleshooting

### Sending a test message

        # echo "testing" | /bin/mail -s "test subject" <email>
        # /usr/lib/sendmail -v <email> < sendstuff
        # date | mailx -v -s "test message" <email>

### If problem, check the mail queue

        /var/spool/clientmqueue

### Regenerate the sendmail.cf file:

- Edit macro config file

        # vi /usr/lib/mail/cf/main.mc

- Regenerate sendmail.cf (will store in cwd)

        # cd /usr/lib/mail/cf
        # make

- Copy sendmail.cf to /etc/mail

### Sendmail Queue

- Default location

        /var/spool/mqueue

- header saved in file beginning with qf
- body saved in file beginning with df


## Terms

### Mail User Agent (MUA)

- Read, reply, compose and dispose of emails.
- e.g. /bin/mail, Microsoft Outlook

### Mail Transport Agent (MTA)

- Delivers mail to MUA, transports mail between MTAs.
- e.g. sendmail

### Local Delivery

- Local mail delivery is done by appending a message to the users mailbox, by feeding the mails message to a program or by appending a message to a file other than the users mailbox.
- Usually, sendmail calls other programs to perform local delivery (these programs are called delivery agents).

### Envelope

- Used to send mail over the network (analogous post office envelopes)
- Information that describes sender / recipient but is not part of the message header is considered envelope information.
- When sending network mails, sendmail must give the remote site a list of sender and recipients separate from and before it sends the mail message (header and body) and this information is considered part of the envelope.
- A given mail message can be sent using many different envelopes, but the header will be common to them all.

## Message Format

- Typical sendmail message format

          Header (added by MUA)
          <blank line>
          Body

- e.g.

          From:  test@company.com Fri Dec 1 00:00:00 2000
          Received: ....
          To: you@company.com
          
          This is a test message.

### `Header` ###

- Most header lines start with a word followed by a colon.

### `Body` ###

- Consists of everything following the first blank line to the end of the file.
- The blank line must be truly blank (i.e. no spaces or tabs)

### `sendmail.cf`

- Main sendmail configuration file.
- Use full pathnames to refer to other files and directories (for security).
- Format:

        O          If line in sendmail.cf begins with "O" specifies configuration option.
        M          Specifies delivery agents.

####  Configuration Options

##### `O AliasFile=/etc/alias`

- Specifies the location of the aliases file.

##### `O QueueDirectory=/var/spool/mqueue`

- Messages that cant be temporarily delivered are placed in the sendmail queue until they can be delivered successfully.
- The message is stored in 2 files in the queue directory.
  - Header information stored in filename that begins with `qf`
  - Body information stored in filename that begins with `df`

##### `O MLocal, P=/bin/mail, F=1sDFMAw5:/|@rmn, S=10. R=20/40`

- Specifies which program (in this case /bin/mail) is used to append mail to a users mailbox.

### Sendmail Macros ###

- Sendmail usually configured through macros.
- Comments in macros are preceded with `dnl #`.

#### `/etc/mail/sendmail.mc`

- Change this line from:

        DAEMON_OPTIONS(`Port=smtp,Addr=127.0.0.1, Name=MTA')dnl

- to (the IP address of the local server):

        DAEMON_OPTIONS(`Port=smtp,Addr=192.168.1.10, Name=MTA')dnl

- Also modify the `LOCAL_DOMAIN` to use the DNS name of the server:

        LOCAL_DOMAIN(`test1.com.au')dnl

  - This needs to be done to prevent mail from been sent as `localhost.localdomain` which can be blocked by spam handlers.


#### `/etc/mail/submit.mc`

- The default sendmail configuration will route email via `localhost`.
- Change the following line to route email to the server:

        FEATURE(`msp', `[192.168.1.10]')dnl

#### Generating sendmail configuration ####

- To generate the sendmail configuration from the macros, run (and reload sendmail for the changes to be applied):


        m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
        m4 /etc/mail/submit.mc > /etc/mail/submit.mc 

### `/etc/mail/access` ###

- List of IP addresses which are allowed to send mail via the mail server.

        # Check the /usr/share/doc/sendmail/README.cf file for a description
        # of the format of this file. (search for access_db in that file)
        # The /usr/share/doc/sendmail/README.cf is part of the sendmail-doc
        # package.
        #
        # by default we allow relaying from localhost...
        Connect:localhost.localdomain           RELAY
        Connect:localhost                       RELAY
        Connect:127.0.0.1                       RELAY
        Connect:192.168.1.1                     RELAY

- To regenerate the `access` database use:

        # makemap hash /etc/mail/access.db < /etc/mail/access


### `/etc/aliases`

- Used to convert 1 recipient name into another.
- In the aliases file, the name on the left of the `:` is changed into the name on the right.
- Names are not case sensitive (e.g. postmaster, Postmaster, POSTMASTER are all equivalent)
- For every envelope that lists a local user as a recipient, sendmail looks up the name in the aliases file (local user is an user that would normally be delivered locally)
- When sendmail matches the recipient (ie. a name on the left of the ":"), it replaces the recipient name with the alias. 
- After a name is substituted, the new name is looked up and the process repeats until no more matches are found.
- Required aliases:
  - `postmaster` - Mail about mail problems sent to the postmaster.
  - `MAILER-DAEMON` - When mail is bounced (returned because it could not be delivered) it is always sent from `MAILER-DAEMON`.
