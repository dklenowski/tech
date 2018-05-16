Categories: fpm
Tags: linux
      debian
      apt

## Building a package with fpm

- The following is a example of a build script for kafka.

        #!/bin/bash
        set -e
        set -u
        
        #
        # globals
        #
        name=kafka
        version="0.8.0"
        description="Apache Kafka is a distributed publish-subscribe messaging system."
        url="https://kafka.apache.org/"
        arch="all"
        section="misc"
        license="Apache Software License 2.0"
        package_version="${version}"
        src_package="kafka-${version}-src.tar.gz"
        origdir="$(pwd)"
        
        #
        # main
        #
        rm -rf ${name}*.deb
        mkdir -p tmp && pushd tmp
        rm -rf kafka
        mkdir -p kafka
        cd kafka
        mkdir -p build/usr/lib/kafka
        mkdir -p build/etc/default
        mkdir -p build/etc/init.d
        mkdir -p build/etc/kafka
        mkdir -p build/var/log/kafka
        
        cp ${origdir}/kafka-broker.default build/etc/default/kafka-broker
        cp ${origdir}/kafka-broker.init.d build/etc/init.d/kafka-broker
        cp ${origdir}/log4j.properties build/etc/kafka/log4j.properties
        cp ${origdir}/server.properties build/etc/kafka/server.properties
        cp ${origdir}/postinst build/
        cp ${origdir}/postrm build/
        
        tar zxf ${origdir}/${src_package}
        cd kafka-${version}-src
        ./sbt update
        ./sbt package
        ./sbt assembly-package-dependency
        mv * ../build/usr/lib/kafka
        cd ../build
        
        /var/lib/gems/1.8/gems/fpm-1.0.2/bin/fpm -t deb \
            -n ${name} \
            -v ${version}${package_version} \
            --description "${description}" \
            --url="{$url}" \
            -a ${arch} \
            --category ${section} \
            --vendor "" \
            --license "${license}" \
            -m "${USER}@localhost" \
            --prefix=/ \
            --after-install=postinst \
            --after-remove=postrm \
            -s dir \
            -- .
        
        mv kafka*.deb ${origdir}
        popd

- Note, the directory where this script was located also contained the following files


        kafka-broker.default
        kafka-broker.init.d
        log4j.properties
        postinst
        postrm
        server.properties