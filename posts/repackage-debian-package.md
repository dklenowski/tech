Categories: linux
Tags: linux
      debian
      apt

1. Extract deb package

        # dpkg-deb -x <package.deb> <dir>
 
2. Extract control-information from a package

        # dpkg-deb -e <package.deb> <dir/DEBIAN>
 
3. After completed to make changes to the package, repackage the deb

        # dpkg-deb -b <dir> <new-package.deb>