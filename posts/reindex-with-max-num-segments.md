Categories: elastic
Tags: elastic

## Find the index you want

    dave@test ~> curl 127.1:9200/_cat/indices
    green open buy_index_2018_05_21_144655360 8 5 3153313 873693 47.9gb 7.7gb


## See how many segments the index has

    dave@test ~> curl -s  -X GET "localhost:9200/_cat/segments/buy_index_2018_05_21_144655360" | wc -l
    1278

## Cleanup the segments

`max_num_segments` specifies the number of segments you wish to have after the optimize operation is called.

    curl -XPOST 'http://localhost:9200/buy_index_2018_05_21_144655360/_optimize?max_num_segments=1000'
    curl -XPOST 'http://localhost:9200/buy_index_2018_05_21_144655360/_optimize?max_num_segments=900'
    curl -XPOST 'http://localhost:9200/buy_index_2018_05_21_144655360/_optimize?max_num_segments=800'
