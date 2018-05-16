Categories: ruby
Tags: empty

        str=somemethod()
        if not str.nil? and not str.empty?
          # somemethod() returned something useful
        else
          # somemethod() did not return anything useful
        end


- Note, a string is not nil when empty, which is why you must check that it is not nil and not empty.
- The conditional could also have been written:

        str=somemethod()
        if !str.nil? && !str.empty?
