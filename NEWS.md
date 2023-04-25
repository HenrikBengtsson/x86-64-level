# Version (development version)

## New Features

 * Now `x86-64-level` asserts that the input CPU flags are of the
   correct format, which is assumed to be only lower-case letters,
   digits, and underscores.

## Bug Fixes

 * Calling `x86-64-level --assert=""` would produce error message
   `merror: command not found` and not the intended `ERROR: Option
   '--assert' must not be empty`.

## Miscellaneous

 * Add unit tests.


# Version 0.2.1 [2023-01-18]

 * Now `--assert` reports also on the CPU name.
 

# Version 0.2.0 [2023-01-18]

## New Features

 * Add support for `x86-64-level --assert=<level>`.
 
 * Add support for `cat /proc/cpuinfo | x86-64-level -`.


# Version 0.1.0 [2022-12-17]

## New Features

 * Created.
