Categories: python
Tags: python
      args

    import argparse
    ...
    if __name__ == '__main__':
      parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter, description='Arg parser.')
      parser.add_argument('--mysql-user', help='MySQL user', required=True)
      parser.add_argument('--mysql-pass', help='MySQL password', required=True)
      parser.add_argument('-p', '--port', help='the port to run on', required=True, type=int)
      parser.add_argument('-f', '--fill-percent', help='the max fill percentage', required=True, type=float)
      parser.add_argument('--log-file', help='The log file for this script.')
      parser.add_argument('-v', '--verbose', help='Be verbose', action='store_true', default=False)

      args = parser.parse_args()
      port = args.port
      log.info("running on port %d", port)
