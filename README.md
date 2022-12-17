[![shellcheck](https://github.com/HenrikBengtsson/x86-64-level/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/HenrikBengtsson/x86-64-level/actions/workflows/shellcheck.yml)

# x86-64-level - Get the x86-64 Microarchitecture Level on the Current Machine

TL;DR: The `x86-64-level` tool identifies the current CPU supports
x86-64-v1, x86-64-v2, x86-64-v3, or x86-64-v4.


# Background

**x86-64** is a 64-bit version of the x86 CPU instruction set
supported by AMD and Intel CPUs among others.  Since the first
generations of CPUs, more low-level CPU features have been added over
the years.  The x86-64 CPU features can be grouped into four [CPU
microarchitecture levels]:

| Level     | CPU Features
|:----------|:---------------------------------------------------
| x86-64-v1 | CMOV, CX8, FPU, FXSR, MMX, OSFXSR, SCE, SSE, SSE2
| x86-64-v2 | CMPXCHG16B, LAHF-SAHF, POPCNT, SSE3, SSE4\_1, SSE4\_2, SSSE3
| x86-64-v3 | AVX, AVX2, BMI1, BMI2, F16C, FMA, LZCNT, MOVBE, OSXSAVE
| x86-64-v4 | AVX512F, AVX512BW, AVX512CD, AVX512DQ, AVX512VL

The x86-64-v1 level is the same as the original, baseline x86-64
level.  These levels are subsets of each other, i.e. x86-64-v1 ⊂
x86-64-v2 ⊂ x86-64-v3 ⊂ x86-64-v4.


Software can be written so that they use the most powerful set of CPU
features available.  This optimization happens at compile time and
allows the software to run more efficiently.  However, a software
binary that was compiled towards the x86-64-v4 level cannot run on an
older machine with a CPU that only supports a x86-64-v3.  If we
attempt to run the software on the older machine, it will crash and we
might get something like:

```
 *** caught illegal operation ***
address 0x2b3a8b234ccd, cause 'illegal operand'
```

This is because the older CPU does not understand one of the low-level
instructions ("operand").  Note that the software might not crash each
time.  It will only do so if it reach the part of the code that uses
the never CPU instructions.

In constrast, if we compile the software on the older x86-64-v3
machine, the produced binary will only use x86-64-v3 instructions and
will therefor also run on the newer x86-64-v4 machine.

Tips: If you work on a high-performance compute (HPC) environment with
compute nodes of different generations of CPUs, and you want a smooth
ride, compile your software tools to use the oldest x86-64 level.
This won't make best use of the more modern CPUs, but it will run on
all compute nodes, so you won't run into the 'caught illegal
operation' problem.


# Finding CPU's x86-64 level

This tool, `x86-64-level`, allows you to query the which x86-64 level
the CPU on current machine supports.  For example,

```sh
$ x86-64-level
3
```

If you want to know an "explanation", specify option `--verbose`, e.g.

```sh
$ x86-64-level --verbose
Identified x86-64-v3, because x86-64-v4 requires 'avx512f', which
this CPU [Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz] does not support
3
```


## Installation

The `x86-64-level` tool is a standalone Linux Bash script that queries
`/proc/cpuinfo`.  To install it, download the script and set the executable flag;

```sh
$ curl -L -O https://raw.githubusercontent.com/HenrikBengtsson/x86-64-level/main/x86-64-level
$ chmod ugo+x x86-64-level
```

To verify it works, try:

```sh
$ ./x86-64-level --help
$ ./x86-64-level --version
$ ./x86-64-level
```

## License

The content of this repository is released under the [CC BY-SA 4.0]
license.


## Authors

* Henrik Bengtsson (expanded on [Gilles' implementation])
* StackExchange user [Gilles]
* StackExchange user [gioele]


[CPU microarchitecture levels]: https://www.wikipedia.org/wiki/X86-64#Microarchitecture_levels
[Gilles' implementation]: https://unix.stackexchange.com/a/631320
[Gilles]: https://stackexchange.com/users/164368/
[gioele]: https://unix.stackexchange.com/users/14861/
[CC BY-SA 4.0]: https://creativecommons.org/licenses/by-sa/4.0/

