# Version (development version)

## New Features

 * Now `x86-64-level` gives an informative error, if there is no
   `/proc/cpuinfo` file.

 * Now `x86-64-level` warns, if no x86-64 support is identified,
   although the operating system is 64-bit.  Then the CPU flags
   reported in `/proc/cpuinfo` are incomplete, which can happen in a
   virtual machine.

 * Now `--verbose` reports on all CPU flags that are missing for the
   next x86-64 level, and not only the first one found.

 * Now `--verbose` and `--assert=<level>` report "no x86-64 level",
   when the CPU does not support x86-64 at all, e.g. an i686 CPU.
   Previously, they reported the non-existing level "x86-64-v0".

## Bug Fixes

 * Calling `x86-64-level` with a misspelled option, e.g.
   `--ass--ert=2`, would be silently accepted as `--assert=2`, because
   all `--` were dropped.

 * Calling `x86-64-level --assert=2=9` would be silently accepted as
   `--assert=9`, because the option value was parsed from the last
   `=`, and not the first one.

 * `x86-64-level` would report on the CPU flags being malformed, when
   there was no `flags` entry at all.  Also, an empty `flags` entry
   would silently give level 0.

 * An error on invalid input would report on the error but not always
   terminate.

 * `--verbose` would not explain the identified level, when the CPU
   supports the highest level, i.e. x86-64-v4.

## Miscellaneous

 * Remove stray `--assert` flag, which had no effect. Note that
   `--assert=<level>` remains.


# Version 0.2.2 [2023-05-25]

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
