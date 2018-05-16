Categories: solaris
Tags: package
      pkginfo
      pkgadd

### Notes ###

- Solaris package format is a proprietary format.
- Useful resource for packages http://www.sunfreeware.com

### Adding a package ###

      # pkgadd –d . <package_name>.pkg  // if in single file
      # pkgadd –d <package_dir>         // if directory format (does not have the  full stop)

- You may have to play around with the `.` (package spooling can be strange).

### Removing a package ###

      # pkgrm <pkg_name>

### Listing Packages ###

      # pkginfo

- To view "long" information include the `-l` flag:

        bash-2.03# pkginfo -l SMClibgcc
           PKGINST:  SMClibgcc
              NAME:  lgcc
          CATEGORY:  application
              ARCH:  sparc
           VERSION:  3.3
           BASEDIR:  /usr/local/lib
            VENDOR:  Free Software Foundation
            PSTAMP:  Steve Christensen
          INSTDATE:  Sep 24 2003 17:30
             EMAIL:  steve@smc.vnet.net
            STATUS:  completely installed
             FILES:       15 installed pathnames
                           1 directories
                           4 executables
                       60374 blocks used (approx)


### Determine what package a file belongs to ###

      #  pkgchk -l -p /usr/bin/perl
      Pathname: /usr/bin/perl
      Type: symbolic link
      Source of link: ../perl5/5.6.1/bin/perl
      Referenced by the following packages:
              SUNWpl5u
      Current status: installed

### Listing files in a package ###

- If the package was distributed as a directory, look in the `pkgmap` file.
- If the package was distributed as a single file, you need to extract the file and then check the `pkgmap`, e.g.

        bash-3.00# pkgtrans binutils-2.17-sol10-x86-local .
        
        The following packages are available:
          1  SMCbinut     binutils
                          (x86) 2.17
        
        Select package(s) you wish to process (or 'all' to process
        all packages). (default: all) [?,??,q]:
        Transferring <SMCbinut> package instance
        bash-3.00# cat SMCbinut/pkgmap |grep as
        1 f none bin/as 0755 bin bin 878344 27593 1179809946

### Creating a package ###

1.  Generate a list of `<package>`.files to include in the package.

2.  Create the `prototype` file.

          # cat <package>.files | pkgproto > prototype

3.  Add the `preinstall` (optional), `postinstall` (optional) and `pkginfo` files to the `prototype` file.

          i preinstall
          i postinsrtall
          i pkginfo

4.  Create the package

          # pkgmk -r <basedir> -d <location>
            -r <basedir>  Base directory where to find files.
            -d <location> Where to put the package.

5. Create a package file.

          # pkgtrans ./ ./<package_name>.pkg <package_dir>


### Patching ###

- Sun usually distributes Patch “Clusters” with an associated install script (available on sunsolve/oracle and requires login).

#### View currently installed patches ####

      # showrev -p

### Script

    #!/usr/bin/perl
    # 
    # davek, makes a relocatable solaris package
    #
    use strict;
    use warnings;
    use File::Find;
    use Cwd;
    use File::Path;
    
    #
    # globals
    #
    
    my $pkgproto="pkgproto";
    my $cp = "cp"; 
    my $tar = "tar";
    my $pkgmk = "pkgmk";
    my $spooldir = "/var/spool/pkg";
    
    my $cwd = Cwd::getcwd();
    my $stagedir=$cwd . "/staging";
    
    my $protostr;
    my $abspkgdir;
    
    my $pkgdir;  # ARGV[0]
    my $app;     # ARGV[1]
    my $vers;    # ARGV[2]
    
    my %pkgconfig = ( "depend" => 1,  
                      "pkginfo" => 1, 
                      "postinstall" => 1, 
                      "preinstall" => 1 );
    
    #
    # methods
    #
    
    sub logmsg {
      my ( $code, $msg ) = @_;
      print "[" . uc($code) . "] - $msg\n";
    }
    
    sub usage {
      print<<EOF
        Usage: perl makePackage.pl <dir> <app> <version>
            <dir>       Directory containing all package contents.
            <app>       The application path, everthing else is considered
                        relative to root.
            <version>   The version (used to write the tar file).
    EOF
    ;
      exit(1);
    }
    
    #
    # main
    # 
    
    if ( !@ARGV ) {
      usage();
    }
    
    $pkgdir = $ARGV[0];
    $app = $ARGV[1];
    $vers = $ARGV[2];
    
    if ( !$app ) {
      logmsg('error', 'No application path defined');
      usage();
    } elsif ( !$vers ) {
      logmsg('error', 'No version defined');
      usage();
    } elsif ( !-d($pkgdir) ) {
      logmsg('error', 'No package directory defined');
      usage();
    }
    
    $pkgdir =~ s/\/$//; # strip trailing /
    $abspkgdir = $cwd . "/" . $pkgdir;
    
    my $dir;
    
    # cleanup
    $dir = "$stagedir/$pkgdir";
    if ( -d($dir) ) {
      logmsg('info', "Deleting existing staging directory $dir");
      rmtree($dir, 0, 1);
    }
    
    # copy all files to staging
    logmsg('info', "Syncing files from $pkgdir to staging $stagedir");
    system("$cp -r -p $cwd/$pkgdir/ $stagedir");
    
    my $protoOut;
    my @lines;
    
    $protoOut = `$pkgproto $stagedir/$pkgdir`;
    @lines = split(/\n/, $protoOut);
    $protostr = "";
    
    my @flds;
    my $abs;
    my $rel;
    my $dolinks;
    my $proto;
    
    foreach my $line ( @lines ) {
      @flds = split(/[ ]+/, $line, 6);
      $abs = $flds[2];
      $rel = $flds[2];
      
      $rel =~ s/$stagedir\/$pkgdir\///;
      $dolinks = 0;
    
      if ( defined($pkgconfig{$rel}) ) {
        $protostr .= "i $rel\n";
      } else {
        if ( $rel =~ m/^$app/ ) {
          $flds[2] = "$rel=$abs";
        } else {
          # an absolute path
          if ( -d($abs) ) {
            # ignore
            next;
          }
          $flds[2] =  "/${rel}=$abs";
          if ( $flds[2] =~ m/init\.d/ ) {
            $dolinks = 1;
          }
        }
        $proto = join(' ', @flds);
        if ( $dolinks ) {
          $protostr .= "d none /etc ? ? ?\n";
          $protostr .= "d none /etc/init.d ? ? ?\n";
          $protostr .= "d none /etc/rc0.d ? ? ?\n";
          $protostr .= "d none /etc/rc1.d ? ? ?\n";
          $protostr .= "d none /etc/rc2.d ? ? ?\n";
          $protostr .= "d none /etc/rc3.d ? ? ?\n";
          $protostr .= "d none /etc/rcS.d ? ? ?\n";
        }
    
        $protostr .= $proto . "\n";
        if ( $dolinks ) {
          $protostr .= "s none /etc/rc0.d/K99$app=/etc/init.d/$app\n";
          $protostr .= "s none /etc/rc1.d/K99$app=/etc/init.d/$app\n";
          $protostr .= "s none /etc/rc2.d/K99$app=/etc/init.d/$app\n";
          $protostr .= "s none /etc/rc3.d/S99$app=/etc/init.d/$app\n";
          $protostr .= "s none /etc/rcS.d/K99$app=/etc/init.d/$app\n";
        }
      }
    }
    
    my $file;
    my $spoolpkg;
    my $tarfile;
    
    logmsg('info', "Dumping prototype to $file");
    
    $file = "$stagedir/$pkgdir/prototype";
    if ( !open(INP, ">$file") ) {
      logmsg('error', "Failed open of $file : $!");
      exit(1);
    }
    print INP $protostr;
    close(INP);
    
    $spoolpkg = "$spooldir/$pkgdir";
    if ( -d($spoolpkg) ) {
      logmsg('info', "Removing old spool directory $spoolpkg");
      rmtree($spoolpkg, 0, 1);
    }
    
    logmsg('info', "Making package in $file");
    
    $file = "$stagedir/$pkgdir";
    chdir($file);
    system($pkgmk);
    
    if ( !-d($spoolpkg) ) {
      logmsg('error', "Failed to make package $spoolpkg");
      exit(1);
    }
    
    logmsg('info', "Creating package tar $tarfile");
    
    $tarfile = "${cwd}/${pkgdir}_${vers}.tar";
    chdir($spooldir);
    system("tar cvf $tarfile $pkgdir");
