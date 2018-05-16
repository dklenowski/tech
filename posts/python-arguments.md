Categories: python
Tags: python

## Python Arguments

    import argparse
    ..
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
                                      description='Awesome script.')
    parser.add_argument('--username', help='User', required=True)
    parser.add_argument('--password', help='Password', required=True)
    parser.add_argument('--var1', help='The number of seconds of lag to allow before warn.', type=int, required=True)
    args = parser.parse_args()

    print "username=%s" % args.username
    print "var1=%d" % args.var1

