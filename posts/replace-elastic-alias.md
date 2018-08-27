Categories: elastic
Tags: elastic

## Replace an existing elastic alias

    curl -XPOST localhost:9200/_aliases -d '{
        "actions" : [
           { "add" : { "index" : "buy_index_2018_08_23_094141944", "alias" : "buy_v1" } },
            { "remove" : { "index" : "buy_index_2018_08_17_120037410", "alias" : "buy_v1" } }
        ]
    }'
