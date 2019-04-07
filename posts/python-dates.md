Categories: python 
Tags: python
      date
      time 

# Current Time

## Float (epoch)

	time.time()

## Int (epoch)

	int(time.time())


# Printing

### String from epoch

- epoch is `int`.

		time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(epoch))

### String from now

		datetime.datetime.now()

# Parsing


## Converting a time `t` to a `datetime` object

	from dateutil import parser

	t = '09:53'
	s = time.strftime('%Y-%m-%d', time.localtime(int(time.time())))
	d = parser.parse("%s %s" % (s, t))
	epoch = time.mktime(d.timetuple())

## Difference between 2 dates

	def diff_date(date_1, date_2):
    	dt1 = parser.parse(date_1)
    	epoch1 = time.mktime(dt1.timetuple())

    	dt2= parser.parse(date_2)
    	epoch2 = time.mktime(dt2.timetuple())

    	sec = int(epoch2)-int(epoch1)
    	return sec

   

