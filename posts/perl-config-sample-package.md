Categories: perl
Tags: config
      package

Saves creating subroutines with long argument lists. Embed inside the main perl file.

    package Config;
     sub new { bless {} };
     sub conf { return( getset(@_, 'conf') ); }
     sub project { return( getset(@_, 'project') ); }
     sub base { return( getset(@_, 'base') ); }
     sub path { return( getset(@_, 'repo_path') ); }
     sub url { return( getset(@_, 'repo_url') ); }
    
      sub getset {
        if ( !@_ || (@_ &amp;lt; 2) ) {
          return(undef);
        }
    
        if ( @_ == 2 ) {
          # getter 0=self, 1=key
          return($_[0]-&amp;gt;{$_[1]});
         }
    
         # setter 0=self, 1=val, 2=key
         $_[0]-&amp;gt;{$_[2]} = $_[1];
      }
