Categories: linux
Tags: process memory
      process


## Linux Process Memory

- Memory parameters for a process found in `/proc/[pid]/status`

### `VmStk`

- Stack size.
- Use gdb (figure out which function/s using stack)

### `VmExe`

- Executable size.
- Use `nm` (list symbols in object files) to determine what functions are taking the greatest space and prune unnecessary functionality.
- e.g.

    # nm -S -size-sort

### `VmLib`

-Library size (shared libraries used by application).
-Use ldd to determine what shared libraries have been compiled into application.

### `VmData`

- Process data area, heap.
- Requires a profiler to troubleshoot.