Categories: linux
            redhat
Tags: rpm

To build a rpm (along with source rpm):

    cd /usr/src/redhat
    rpmbuild -ba SPECS/<file.spec>

To build a rpm only:

    cd /usr/src/redhat
    rpmbuild -bb SPECS/<file.spec>

## RPM Directory Structure

    /usr/src/redhat/rpm
            BUILD           Where source extracted and compilation takesplace.
            RPMS            Successfully built RPM's.
                i686
                noarch
                ..
            SOURCES         Gzipped tarballs.
            SPECS           Spec files for each rpm.
            SRPMS           When creation source rpms (via rpmbuild).
            tmp             %{_tmppath} and optionally %{buildroot}

## Example .spec file's

### fcgi-2.4.0

    %define _topdir         /home/rpmbuild/rpm
    %define _tmppath        %{_topdir}/tmp
    %define _prefix         /usr/local

    %define name      fcgi
    %define summary   CGI extension API written in C.
    %define version   2.4.0
    %define release   1.0
    %define license   GPL
    %define arch      x86_64
    %define group     Development/Libraries
    %define source    %{name}-%{version}.tar.gz
    %define url       http://www.fastcgi.com/
    %define vendor    Open Market
    %define packager  David Klenowski
    %define buildroot %{_tmppath}/%{name}-root

    Name:      %{name}
    Version:   %{version}
    Release:   %{release}
    Packager:  %{packager}
    Vendor:    %{vendor}
    License:   %{license}
    Summary:   %{summary}
    Group:     %{group}
    Source:    %{source}
    URL:       %{url}
    Prefix:    %{_prefix}
    BuildRoot: %{buildroot}
    BuildArch: %{arch}

    %description
    API for accessing CGI extensions.

    %prep
    %setup -q

    %build
    ./configure --prefix=/usr/local

    %configure
    make

    %install
    rm -rf %{buildroot}
    make install DESTDIR=%{buildroot}

    %clean
    rm -rf %{buildroot}

    %files
    %defattr(-,root,root)
    /usr/local/lib/*
    /usr/local/include/*
    /usr/local/bin/*

### cmemcache-0.9.spec

    %define _topdir         /home/rpmbuild/rpm
    %define _tmppath        %{_topdir}/tmp
    %define _prefix     /usr/local/python2.5

    %define name      cmemcache
    %define summary   Python memcached bindings.
    %define version   0.9
    %define release   1.el5
    %define license   GPL
    %define arch      x86_64
    %define group     Development/Libraries
    %define source    %{name}-%{version}.tar.gz
    %define url       http://gijsbert.org/cmemcache/
    %define vendor    Gijsbert de Haan
    %define packager  David Klenowski
    %define buildroot %{_tmppath}/%{name}-root

    Name:      %{name}
    Version:   %{version}
    Release:   %{release}
    Packager:  %{packager}
    Vendor:    %{vendor}
    License:   %{license}
    Summary:   %{summary}
    Group:     %{group}
    Source:    %{source}
    URL:       %{url}
    Prefix:    %{_prefix}
    BuildRoot: %{buildroot}
    BuildArch: %{arch}

    %description
    cmemcache provides Python bindings into memcached through the C library
    libmemcached.

    %prep
    %setup -q

    %build
    LDFLAGS=-L/usr/local/python-2.5.2/lib; export LDFLAGS
    python setup.py build

    %install
    rm -rf %{buildroot}
    python setup.py install --prefix=%{buildroot}%{prefix}

    %clean
    rm -rf %{buildroot}

    %files
    %defattr(-,root,root)
    %{prefix}/lib

### easy-install-0.6c8.spec

    %define _topdir         /home/rpmbuild/rpm
    %define _tmppath        %{_topdir}/tmp

    %define name      python-easy-install
    %define summary   easy_install script for python modules.
    %define version   0.6c8
    %define release   1.0
    %define license   GPL
    %define arch      x86_64
    %define group     Development/Libraries
    %define url       http://peak.telecommunity.com/DevCenter/EasyInstall
    %define vendor    PEAK
    %define packager  David Klenowski

    Name:      %{name}
    Version:   %{version}
    Release:   %{release}
    Packager:  %{packager}
    Vendor:    %{vendor}
    License:   %{license}
    Summary:   %{summary}
    Source:    %{source}
    Group:     %{group}
    URL:       %{url}

    AutoReq: no
    Requires: python

    %description
    easy_install scripts for Python 2.5.2.

    %files
    %defattr(-,root,root)
    /usr/local/python-2.5.2/bin/easy_install
    /usr/local/python-2.5.2/bin/easy_install-2.5
    /usr/local/python-2.5.2/lib/python2.5/site-packages/setuptools-0.6c8-py2.5.egg
    /usr/local/python-2.5.2/lib/python2.5/site-packages/setuptools.pth

### php-5.2.5.spec

    %define _topdir         /home/rpmbuild/rpm
    %define _tmppath        %{_topdir}/tmp
    %define _prefix         /usr/local/php-5.2.5
    %define _defaultdocdir  %{_prefix}/doc
    %define _mandir         %{_prefix}/man

    %define name      php
    %define summary   The PHP HTML-embedded scripting language. (PHP: Hypertext Preprocessor)
    %define version   5.2.5
    %define release   3.0
    %define license   GPL
    %define arch      x86_64
    %define group     Development/Languages
    %define source    %{name}-%{version}.tar.gz
    %define url       http://www.php.net/
    %define vendor    www.php.net
    %define packager  David Klenowski
    %define buildroot %{_tmppath}/%{name}-root

    Name:      %{name}
    Version:   %{version}
    Release:   %{release}
    Packager:  %{packager}
    Vendor:    %{vendor}
    License:   %{license}
    Summary:   %{summary}
    Group:     %{group}
    Source:    %{source}
    URL:       %{url}
    Prefix:    %{_prefix}
    BuildArch: %{arch}

    %description
    PHP is an HTML-embedded scripting language. PHP attempts to make it
    easy for developers to write dynamically generated webpages. PHP also
    offers built-in database integration for several commercial and
    non-commercial database management systems, so writing a
    database-enabled webpage with PHP is fairly simple. The most common
    use of PHP coding is probably as a replacement for CGI scripts.

    This php is a custom package developed for APN digital and installs
    in /usr/local/php-5.2.5.

    %prep
    %setup -q

    %configure
    ./configure --prefix=/usr/local/php-5.2.5 --with-apxs2 --with-mysql --with-mysqli=/usr/bin/mysql_config --with-jpeg-dir=/usr/lib64 --with-png-dir=/usr/lib64 --with-zlib-dir=/usr/lib64 --with-xpm-dir=/usr/lib64 --with-zlib --with-bz2 --with-gd --enable-gd-native-ttf --with-ttf --with-gettext --enable-ftp --enable-mbstring --with-curl --with-libdir=lib64 --enable-memory-limit --with-config-file-path=/etc

    %build
    make install

    %install

    %clean
    rm -rf %{buildroot}

    %files
    %defattr(-,root,root)
    /usr/local/php-5.2.5/bin/*
    /usr/local/php-5.2.5/etc/*
    /usr/local/php-5.2.5/include/*
    /usr/local/php-5.2.5/lib/*
    /usr/lib64/httpd/modules/libphp5.so
    %defattr(-,root,root)
    /usr/local/php-5.2.5/man/man1/php.1
    /usr/local/php-5.2.5/man/man1/php-config.1
    /usr/local/php-5.2.5/man/man1/phpize.1

### python-imaging-1.1.6.spec

Note the .tar.gz file was created from Imaging-1.1.6.tar.gz

    %define _topdir         /home/rpmbuild/rpm
    %define _tmppath        %{_topdir}/tmp
    %define _prefix         /usr/local/python-2.5.2
    %define _defaultdocdir  %{_prefix}/doc
    %define _mandir         %{_prefix}/share/man
    
    
    %define name      python-imaging
    %define summary   Python Imaging Library
    %define version   1.1.6
    %define release   1.0
    %define license   GPL
    %define arch      x86_64
    %define group     Development/Libraries
    %define source    %{name}-%{version}.tar.gz
    %define url       http://www.pythonware.com/products/pil
    %define vendor    Secret Labs AB (PythonWare)
    %define packager  David Klenowski
    
    
    Name:      %{name}
    Version:   %{version}
    Release:   %{release}
    Packager:  %{packager}
    Vendor:    %{vendor}
    License:   %{license}
    Summary:   %{summary}
    Group:     %{group}
    Source:    %{source}
    URL:       %{url}
    Prefix:    %{_prefix}
    BuildArch: %{arch}
    
    
    %description
    Python Imaging Library for Python 2.5.2.
    
    
    %prep
    %setup -q
    
    
    %build
    cp setup.py setup.py.orig
    sed -e 's/^FREETYPE_ROOT = None$/FREETYPE_ROOT = "\/usr\/lib64"/' \
        -e 's/^JPEG_ROOT = None$/JPEG_ROOT = "\/usr\/lib64"/' \
        -e 's/^ZLIB_ROOT = None$/ZLIB_ROOT = "\/usr\/lib64"/' setup.py.orig > setup.py
    
    
    python setup.py build
    
    
    %install
    python setup.py install
    
    
    %files
    %defattr(-,root,root)
    %{prefix}/lib/python2.5/site-packages/PIL.pth
    %{prefix}/lib/python2.5/site-packages/PIL
    %{prefix}/bin/pilconvert.py
    %{prefix}/bin/pildriver.py
    %{prefix}/bin/pilfile.py
    %{prefix}/bin/pilfont.py
    %{prefix}/bin/pilprint.py
    ruby-fcgi-0.8.6.spec
    
    %define _topdir         /home/rpmbuild/rpm
    %define _tmppath        %{_topdir}/tmp
    %define _prefix         /usr/local
    
    %define name      ruby-fcgi
    %define summary   Ruby extensions for access to fcgi.
    %define version   0.8.6
    %define release   1.0
    %define license   GPL
    %define arch      x86_64
    %define group     Development/Libraries
    %define source    %{name}-%{version}.tar.gz
    %define url       http://www.rubyforge.org/
    %define vendor    rubyforge.org
    %define packager  David Klenowski
    %define buildroot %{_tmppath}/%{name}-root
    
    Name:      %{name}
    Version:   %{version}
    Release:   %{release}
    Packager:  %{packager}
    Vendor:    %{vendor}
    License:   %{license}
    Summary:   %{summary}
    Group:     %{group}
    Source:    %{source}
    URL:       %{url}
    Prefix:    %{_prefix}
    BuildRoot: %{buildroot}
    BuildArch: %{arch}
    
    %description
    Ruy extensions for accessing the CGI C CGI extension API (fcgi).
    
    %prep
    %setup -q
    
    %build
    ruby install.rb config --prefix=%{buildroot}/usr
    ruby install.rb setup
    
    %install
    rm -rf %{buildroot}
    ruby install.rb install
    
    %clean
    rm -rf %{buildroot}
    
    %files
    %defattr(-,root,root)
    /usr/lib/*
    /usr/lib64/*