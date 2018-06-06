Categories: java
Tags: maven
      deps
      package

## Using maven to build a package with dependencies

Use a pom file similar to the one below and run the maven command:

    mvn clean compile assembly:single

Sample `pom.xml`

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
    
        <groupId>com.hadoop.hive</groupId>
        <artifactId>pop-hive</artifactId>
        <version>1.0-SNAPSHOT</version>
    
        <repositories>
            <repository>
                <id>cloudera</id>
                <url>https://repository.cloudera.com/artifactory/cloudera-repos/</url>
            </repository>
        </repositories>
    
        <!--
        <pluginRepositories>
            <pluginRepository>
                <id>onejar-maven-plugin.googlecode.com</id>
                <url>http://onejar-maven-plugin.googlecode.com/svn/mavenrepo</url>
            </pluginRepository>
        </pluginRepositories>
        -->
    
        <build>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.3</version>
                    <configuration>
                        <source>1.8</source>
                        <target>1.8</target>
                    </configuration>
                </plugin>
    
                <!--
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-jar-plugin</artifactId>
                    <configuration>
                        <archive>
                            <manifest>
                                <mainClass>com.ebay.ecg.australia.hadoop.hive.PopularSearch</mainClass>
                            </manifest>
                        </archive>
                    </configuration>
                </plugin>
                <plugin>
                    <groupId>org.dstovall</groupId>
                    <artifactId>onejar-maven-plugin</artifactId>
                    <version>1.4.4</version>
                    <executions>
                        <execution>
                            <goals>
                                <goal>one-jar</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
                -->
    
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-assembly-plugin</artifactId>
                    <version>2.4</version>
                    <configuration>
                        <archive>
                            <manifest>
                                <mainClass>com.hadoop.hive.Pop</mainClass>
                            </manifest>
                        </archive>
                        <descriptorRefs>
                            <descriptorRef>jar-with-dependencies</descriptorRef>
                        </descriptorRefs>
                    </configuration>
                    <executions>
                        <execution>
                            <phase>package</phase>
                            <goals>
                                <goal>single</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
    
            </plugins>
        </build>
    
        <dependencies>
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>5.1.2</version>
            </dependency>
            <dependency>
                <groupId>org.apache.hadoop</groupId>
                <artifactId>hadoop-common</artifactId>
                <version>2.6.0-cdh5.4.5</version>
            </dependency>
            <dependency>
                <groupId>org.apache.hive</groupId>
                <artifactId>hive-jdbc</artifactId>
                <version>1.1.0-cdh5.4.5</version>
            </dependency>
            <dependency>
                <groupId>org.slf4j</groupId>
                <artifactId>slf4j-api</artifactId>
                <version>1.7.8</version>
            </dependency>
            <dependency>
                <groupId>org.slf4j</groupId>
                <artifactId>slf4j-simple</artifactId>
                <version>1.7.8</version>
            </dependency>
        </dependencies>
    
    
    </project>