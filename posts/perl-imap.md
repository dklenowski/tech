Categories: perl
Tags: imap

### Package ###

        use Mail::IMAPClient;

### Initialise Connection ###

        my $imap = Mail::IMAPClient->new(
          Server => 'imap.server',
          User => 'username',
          Authuser => 'imap-username',
          Password => 'password'
          );

### Operations on Folders ###


        my @folders;
        my $ct;
        
        @folders = $imap->folders;
        foreach my $folder ( @folders ) {
          $ct = $imap->message_count($folder);
          print "Folder $folder contains $ct messages.";
        }

