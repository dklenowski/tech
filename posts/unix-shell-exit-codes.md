Categories: unix
Tags: shell
      exit
      exit code

- Range

        0 - 256

- In general shell programs use the following exit codes:

        0       success
        > 0     failure (technically), but could describe certain non-failure conditions.

- To find the exit code:

        # echo $?

