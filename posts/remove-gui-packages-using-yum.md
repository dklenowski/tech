Categories: linux
            yum
Tags: remove
      package
      rpm
      x11
      gnome

    yum remove `rpm -qa | egrep -i "x11|gnome" | sort | uniq` -y