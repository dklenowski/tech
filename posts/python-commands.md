Categories: python
Tags: python
      commands


## Using `subprocess`

    import subprocess
    import logging

    command = '/tmp/run.sh'
    logger.debug('running command %s' % command)

    try:
        p1 = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        output = p1.stderr.read()
        if output == '':
            logger.info('successfully ran %s', cmd)
        else:
            raise Exception('error running %s: %s' % (cmd, output))
    except subprocess.CalledProcessError as e:
        raise Exception('process exited abnormally running %s: %s (%s)' % (cmd, output, str(e)))


## Using `commands`

    import commands

    command = '/tmp/run.sh'
    out = commands.getstatusoutput(command)
    if 'success' not in str(out):
        log.fatal("unable to execute %s:\n%s" % (dsn_create, str(out)))
        sys.exit(1)