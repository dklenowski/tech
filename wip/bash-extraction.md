Categories: bash
Tags: bash scription

# Bash substring Extraction

    ${MYVAR#pattern}       # delete shortest match of pattern from the beginning
    ${MYVAR##pattern}      # delete longest match of pattern from the beginning
    ${MYVAR%pattern}       # delete shortest match of pattern from the end
    ${MYVAR%%pattern}      # delete longest match of pattern from the end
