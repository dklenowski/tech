Categories: golang
Tags: go
      golang
      string
      trim
      space

## Split

    lines := strings.Split(string(output), "\n")
    for i, line := range lines {
      if i == 0 {
        continue
      } else if regexp.MustCompile("^$").MatchString(line) {
        continue
      }

## Trim

    params := strings.TrimSpace(s)

## Trim Suffix

    newfile := strings.TrimSuffix(localfile, ".avro") + ".txt"


