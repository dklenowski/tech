Categories: eclipse
Tags: eclipse
      shortcut
      ide
      native
      library

- Adding native library to a project (avoiding having to insert `DYLD_LIBRARY_PATH` in all run/debug configurations):

    - [right-click] Project and select Properties.
    - [click] on Java Build Path and select the Libraries tab.
    - Expand the jar that requires a native library and select Native library location, then [click] Edit...
    - Update the path.