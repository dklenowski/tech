Categories: redis
Tags: redis

## Default db locations

### Mac

      /Users/<username>/dump.rdb

### Linux

      /var/lib/redis/dump.rdb

## Print redis sets/hashes

			redis 127.0.0.1:6379> keys *
			1) "index"
			2) "processed"

## To dump keys (using cli)

      redis-cli KEYS \* > keys.txt