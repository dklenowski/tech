Categories: python
Tags: pythonic

## Iterate through elements from a file

    iter = ifilter(len, imap(str.strip, open("/tmp/words.txt")))
    for wd in iter:
      print "Word is %s" % wd

## List Comprehension

- Create a list based on some requirements
- e.g.

        def parse():
          words = [ "one", "two", "three", "four"]
          return [i for i in words if len(i) <= 3]

        print parse() # ['one', 'two']


## Timing a function

    def timeof(fn, *args):
      import time
      t = time.time()
      res = fn(*args)
      print "time: ", (time.time() - t)
      return res

