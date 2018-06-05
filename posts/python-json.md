Categories: python
Tags: python
      json


## Read in a json url

    import requests
    try:
        r = requests.get(url)
    except Exception as e:
      log.fatal("url %s is down: %s", url, str(e))

    print "json head=%s" % json['head']

## Convert a string to json

    import json
    output = `run a json command`
    j = json.loads(output)
    print "status=%s" % j['status']
    ..
    topic = j['status']['partitions'][0]['topic']