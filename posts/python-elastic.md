Categories: python
Tags: python
      elastic

# Suggestions

## Completion Suggestor

	location_suggest_mapping = {
	    "settings": {
	        "index": {
	            "number_of_shards": 1,
	            "number_of_replicas": 1
	        }
	    },
	    "mappings": {
	        "world": {
	            "properties": {
	                "suggest": {
	                    "type": "completion"
	                },
	                "txt": {
	                    "type": "keyword"
	                }
	            }
	        }
	    }
	}

## standard

    body = {
        'suggest': {
            'input': term,
            'weight': 1
        }
    }

    es_client.create(index=alias, doc_type=doc_type, id=user_id, body=body)



## `doc_as_upsert`

    body = {
        'doc': {
            'suggest': {
                'input': term,
                'weight': 1
            }
        },
        'doc_as_upsert': True
    }


    es_client.update(index=alias, doc_type=doc_type, id=user_id, body=body)

## Create

    body = {
        'suggest': {
            'input': term,
            'weight': 1,
        },
        'op_type': 'create'
    }

    es_client.create(index=alias, doc_type=doc_type, id=user_id, body=body)
