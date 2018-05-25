Categories: elasticsearch
Tags: cluster
      indexes
      shards

# Cheatsheet

# Queries

## Search

### Match All

    GET /_search
    {
      "query": {
        "match_all": {}
      }
    }

### Term Query

- Exact match (on inverted index)

        GET /video/_search
        {
            "query": {
               "term" : { "display_name" : "hom" }
            }
        }

### Terms Query

        GET /video/_search
        {
          "query": {
            "terms": {
              "block": [
                "a",
                "small",
                "cat",
                "has",
                "another"
              ],
              "minimum_should_match": "2"
            }
          }
        }


### Prefix Query

    GET /video/_search
    { "query": {
        "prefix" : { "display_name" : "ed" }
      }
    }


### Complex Query

    GET /dare/_search
    {
            "query": {
                "bool": {
                    "should": [
                        {"match": {"by_user_id": 2}},
                        {"match": {"for_user_id": 2}}
                    ]
                }
            },
            "sort": [
                {"likes": {"order": "desc"}},
                {"backers": {"order": "desc"}},
                {"views": {"order": "desc"}}
            ]
    }


    GET user/_search
    {
      "query": {
        "bool": {
          "must": [
            {
              "multi_match": {
                "query": "the",
                "type": "phrase_prefix", 
                "fields": ["username","email","nickname"]
              }
            }
          ],
          "filter": {
            "terms": {
              "_id": [
                "1",
                "2",
                "3"
              ]
            }
          }
        }
      }
    }

    GET /video/_search
    {
      "sort": [
        {
          "current_likes": {
            "order": "desc"
          }
        },
        {
          "current_backers": {
            "order": "desc"
          }
        }
      ],
      "query": {
        "bool": {
          "filter": {
            "terms": {
              "group_id": [
                1,
                0
              ]
            }
          },
          "must_not": [
            {
              "match": {
                "user_id": 6
              }
            }
          ],
          "must": [
            {
              "multi_match": {
                "query": "fantastic",
                "type": "phrase_prefix",
                "fields": [
                  "display_name",
                  "title",
                  "tags",
                  "description"
                ]
              }
            }
          ]
        }
      }
    }


### Completion Suggester

    GET user_suggest/_search
    {
      "suggest": {
        "all": {
          "prefix": "Tracy5516Woods@",
          "completion": {
            "field": "suggest",
            "size": 1
          }
        }
      }
    }

# Restarting a node

## Disable shard allocation

    curl -XPUT localhost:9200/_cluster/settings -d '{"transient":{"cluster.routing.allocation.enable": "none"}}'

## Restart node

## Enable shard allocation

    curl -XPUT localhost:9200/_cluster/settings -d '{"transient":{"cluster.routing.allocation.enable": "all"}}'

## General

## Cluster

### Cluster Health

    curl localhost:9200/_cluster/health?pretty

### Cluster settings

    curl 'http://localhost:9200/_cluster/settings?pretty'

### List nodes in the cluster

     curl -s 'localhost:9200/_cat/nodes?v'

### Info about re-assigning

    curl -XPOST "http://localhost:9200/_cluster/reroute?explain"

## Indexes

### List indexes

    curl -XGET 'localhost:9200/_cat/indices?v&pretty'    

### State of Indexes/Shards

    curl -XGET http://localhost:9200/_cluster/state?pretty=true

### List Properties of all Indexes

    curl -XGET 'http://localhost:9200/_all/_mapping?pretty-=true'

### Settings for indexes

    curl -XGET 'localhost:9200/<index>/_settings?pretty'

### Number of Shards for index

    curl -XGET 'http://localhost:9200/<index>/block/_count'

### Modify setting for an index

e.g. change the number of replica's (note, this can be an expensive operation and may affect operation for busy clusters).

    curl -XPUT 'localhost:9200/suggestion_20180121/_settings?pretty' -H 'Content-Type: application/json' -d'
    {
        "index" : {
            "number_of_replicas" : 0
        }
    }
    '

## Aliases

### List Aliases

    curl -XGET 'localhost:9200/_cat/aliases?v&pretty'

## Notes

- An **index** is made up of **shards**.

## Shards

- A **shard** maps to a lucene **instance/index**.

### Primary Shard (aka **shard**)

- An **index** has >= 1 **primary** shards.
- Default 5, cannot be changed after index creation.

### Replica Shard (aka **replica**)

- Each **primary** shard has >= 0 **replica** shards.
- Used for high availability and throughput.

## tokenizer

- Mapping

        PUT /user
        {
          "settings": {
            "index": {
              "number_of_shards": 3,
              "number_of_replicas": 1
            },
            "analysis": {
              "filter": {
                "email": {
                  "type": "pattern_capture",
                  "preserve_original": true,
                  "patterns": [
                    "([^@]+)",
                    "(\\p{L}+)",
                    "(\\d+)",
                    "@(.+)"
                  ]
                }
              },
              "analyzer": {
                "email": {
                  "tokenizer": "uax_url_email",
                  "filter": [
                    "email",
                    "lowercase",
                    "unique"
                  ]
                }
              }
            }
          },
          "mappings": {
            "user": {
              "properties": {
                "id": {
                  "type": "keyword"
                },
                "joined": {
                  "type": "date"
                },
                "name": {
                  "type": "text",
                  "analyzer": "simple",
                  "fields": {
                    "keyword": {
                      "type": "keyword",
                      "ignore_above": 50
                    }
                  }
                },
                "email": {
                  "type": "text",
                  "analyzer": "email",
                  "fields": {
                    "keyword": {
                      "type": "keyword",
                      "ignore_above": 255
                    }
                  }
                }
              }
            }
          }
        }

- Testing

        GET /user/_analyze?analyzer=email
        {
        "text": "eddie.vedder@gmail.com"
        }


## Notes

- Replication is synchronous, i.e. if replica fails, ES will not return response until it is fixed.
- ES has a preference to examine local replica's, will go to primary shard if ES instances doesn't have the info.

### Yellow State

- For shard, typically means ESA cannot assign all replica's (e.g. not enough nodes)