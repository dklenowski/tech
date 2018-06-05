Categories: python
Tags: python
      logging

    import logging
    ..
    if log_file:
      logging.basicConfig(filename=log_file, filemode='w', format="%(asctime)s: [%(levelname)s] - %(message)s")
    else:
      logging.basicConfig(format="%(asctime)s: [%(levelname)s] - %(message)s")
    log.setLevel(logging.INFO)