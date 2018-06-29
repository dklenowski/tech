Categories: puppet
Tags: puppet
      linux


## View Puppet facts

    curl -X GET http://localhost:8080/v3/facts --data-urlencode 'query=["=", "name", "hostname"]'
    curl -sfG http://localhost:8080/v3/nodes --data-urlencode 'query=["=", ["fact", "ipaddress"], "10.41.197.66"]'

### Facts w/ regex's

    curl -X GET http://localhost:8080/v3/facts/mysql_major_version --data-urlencode 'query=["~", "certname", "db*"]'


## View Puppet Resources

    curl 'http://localhost:8080/v3/resources?query=\["=","exported",true\]' 
