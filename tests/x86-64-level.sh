#! /usr/bin/env bash

nerrors=0

echo "x86-64-level ..."

#--------------------------------------------------------------------------
# x86-64-level --version
#--------------------------------------------------------------------------
echo "* x86-64-level --version"
version=$(x86-64-level --version)
exit_code=$?
if [[ ${exit_code} -ne 0 ]]; then
    >&2 echo "ERROR: Exit code is non-zero: ${exit_code}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^[[:digit:]]+([.-][[:digit:]]+)+$" <<< "${version}"; then
    >&2 echo "ERROR: Unexpected version string: ${version}"
    nerrors=$((nerrors + 1))
fi

## Outputs nothing to stderr
stderr=$( { x86-64-level --version > /dev/null; } 2>&1 )
if [[ -n ${stderr} ]]; then
    >&2 echo "ERROR: Detected output to standard error: ${stderr}"
    nerrors=$((nerrors + 1))
fi


#--------------------------------------------------------------------------
# x86-64-level --help
#--------------------------------------------------------------------------
echo "* x86-64-level --help"
help=$(x86-64-level --help)
exit_code=$?
if [[ ${exit_code} -ne 0 ]]; then
    >&2 echo "ERROR: Exit code is non-zero: ${exit_code}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^Version:" <<< "${help}"; then
    >&2 echo "ERROR: Help does not show version: ${help}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^License:" <<< "${help}"; then
    >&2 echo "ERROR: Help does not show license: ${help}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^Source code:" <<< "${help}"; then
    >&2 echo "ERROR: Help does not link to source code: ${help}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^Authors:" <<< "${help}"; then
    >&2 echo "ERROR: Help does not list authors: ${help}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^Examples:" <<< "${help}"; then
    >&2 echo "ERROR: Help does not show examples: ${help}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^Usage:" <<< "${help}"; then
    >&2 echo "ERROR: Help does not show usage: ${help}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^Options:" <<< "${help}"; then
    >&2 echo "ERROR: Help does not show options: ${help}"
    nerrors=$((nerrors + 1))
fi

## Outputs nothing to stderr
stderr=$( { x86-64-level --help > /dev/null; } 2>&1 )
if [[ -n ${stderr} ]]; then
    >&2 echo "ERROR: Detected output to standard error: ${stderr}"
    nerrors=$((nerrors + 1))
fi


#--------------------------------------------------------------------------
# x86-64-level
#--------------------------------------------------------------------------
echo "* x86-64-level"
level=$(x86-64-level)
exit_code=$?
if [[ ${exit_code} -ne 0 ]]; then
    >&2 echo "ERROR: Exit code is non-zero: ${exit_code}"
    nerrors=$((nerrors + 1))
fi
if ! grep -q -E "^[[:digit:]]+$" <<< "${level}"; then
    >&2 echo "ERROR: Non-integer x86-64 level: ${level}"
    nerrors=$((nerrors + 1))
fi
if [[ ${level} -lt 1 ]] || [[ ${level} -gt 4 ]]; then
    >&2 echo "ERROR: x86-64 level out of range [1,4]: ${level}"
    nerrors=$((nerrors + 1))
fi

## Outputs nothing to stderr
stderr=$( { x86-64-level > /dev/null; } 2>&1 )
if [[ -n ${stderr} ]]; then
    >&2 echo "ERROR: Detected output to standard error: ${stderr}"
    nerrors=$((nerrors + 1))
fi


#--------------------------------------------------------------------------
# x86-64-level --assert=<level>
#--------------------------------------------------------------------------
echo "* x86-64-level --assert=<level>"
level=$(x86-64-level)

stderr=$(x86-64-level --assert="${level}" 2>&1)
exit_code=$?
if [[ ${exit_code} -ne 0 ]]; then
    >&2 echo "ERROR: Exit code is non-zero: ${exit_code}"
    nerrors=$((nerrors + 1))
fi

## Outputs nothing to stdout
stdout=$(x86-64-level --assert="${level}")
if [[ -n ${stdout} ]]; then
    >&2 echo "ERROR: Detected output to standard output: ${stdout}"
    nerrors=$((nerrors + 1))
fi


#--------------------------------------------------------------------------
# x86-64-level --assert=1
#--------------------------------------------------------------------------
echo "* x86-64-level --assert=1"
stderr=$(x86-64-level --assert=1 2>&1)
exit_code=$?
if [[ ${exit_code} -ne 0 ]]; then
    >&2 echo "ERROR: Exit code is non-zero: ${exit_code}"
    nerrors=$((nerrors + 1))
fi

## Outputs nothing to stdout
stdout=$( x86-64-level --assert="${level}")
if [[ -n ${stdout} ]]; then
    >&2 echo "ERROR: Detected output to standard output: ${stdout}"
    nerrors=$((nerrors + 1))
fi



#--------------------------------------------------------------------------
# x86-64-level - <<< "flags: avx"
#--------------------------------------------------------------------------
required_flags=(
    "lm cmov cx8 fpu fxsr mmx syscall sse2"
    "cx16 lahf_lm popcnt sse4_1 sse4_2 ssse3"
    "avx avx2 bmi1 bmi2 f16c fma abm movbe xsave"
    "avx512f avx512bw avx512cd avx512dq avx512vl"
)

cpu_flags=("dummy")
for value in "${required_flags[@]}"; do
    cpu_flags+=("${cpu_flags[-1]} ${value}")
done

for truth in $(seq 0 "$((${#cpu_flags[@]} - 1))"); do
    flags=${cpu_flags[${truth}]}

    echo "* x86-64-level - <<< 'flags: ${flags}'"
    level=$(x86-64-level - <<< "flags: ${flags}")
    exit_code=$?
    if [[ ${exit_code} -ne 0 ]]; then
        >&2 echo "ERROR: Exit code is non-zero: ${exit_code}"
        nerrors=$((nerrors + 1))
    fi
    
    if [[ "${level}" -ne "${truth}" ]]; then
        >&2 echo "ERROR: Unexpected level: ${level} != ${truth}"
        nerrors=$((nerrors + 1))
    fi    
    
    ## Outputs nothing to stderr
    stderr=$( { x86-64-level - <<< "flags: ${flags}" > /dev/null; } 2>&1 )
    if [[ -n ${stderr} ]]; then
        >&2 echo "ERROR: Detected output to standard error: ${stderr}"
        nerrors=$((nerrors + 1))
    fi

    ## Option --verbose explains the identified level, on stderr
    echo "* x86-64-level --verbose - <<< 'flags: ${flags}'"
    level=$(x86-64-level --verbose - <<< "flags: ${flags}" 2> /dev/null)
    if [[ "${level}" -ne "${truth}" ]]; then
        >&2 echo "ERROR: Unexpected level: ${level} != ${truth}"
        nerrors=$((nerrors + 1))
    fi

    stderr=$( { x86-64-level --verbose - <<< "flags: ${flags}" > /dev/null; } 2>&1 )
    if [[ $(wc -l <<< "${stderr}") -ne 1 ]]; then
        >&2 echo "ERROR: Expected a single explanation: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    ## Level 0 means no x86-64 support, i.e. there is no 'x86-64-v0'
    if [[ ${truth} -eq 0 ]]; then
        label="no x86-64 level"
    else
        label="x86-64-v${truth}"
    fi
    if ! grep -q -F "Identified ${label}," <<< "${stderr}"; then
        >&2 echo "ERROR: Unexpected explanation: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi
done




#--------------------------------------------------------------------------
# x86-64-level --verbose reports on all missing CPU flags
#--------------------------------------------------------------------------
## An AMD E2-3800 CPU, which has 'avx', but neither 'avx2', 'bmi2', nor
## 'fma', i.e. it is missing three of the x86-64-v3 flags [#11]
flags="lm cmov cx8 fpu fxsr mmx syscall sse2 cx16 lahf_lm popcnt sse4_1 sse4_2 ssse3 avx bmi1 f16c abm movbe xsave"

echo "* x86-64-level --verbose - <<< <CPU missing three x86-64-v3 flags>"
level=$(x86-64-level --verbose - <<< "flags: ${flags}" 2> /dev/null)
if [[ "${level}" -ne 2 ]]; then
    >&2 echo "ERROR: Unexpected level: ${level} != 2"
    nerrors=$((nerrors + 1))
fi

stderr=$( { x86-64-level --verbose - <<< "flags: ${flags}" > /dev/null; } 2>&1 )
if ! grep -q -F "requires 'avx2', 'bmi2', and 'fma', which are not supported" <<< "${stderr}"; then
    >&2 echo "ERROR: Does not report on all missing CPU flags: '${stderr}'"
    nerrors=$((nerrors + 1))
fi


#--------------------------------------------------------------------------
# Exceptions
#--------------------------------------------------------------------------
# x86-64-level --assert=<out of range>
for level in -1 0 5 100; do
    echo "* x86-64-level --assert=${level} (exception)"
    stderr=$(x86-64-level --assert="${level}" 2>&1)
    exit_code=$?
    if [[ ${exit_code} -eq 0 ]]; then
        >&2 echo "ERROR: Exit code should be non-zero: ${exit_code}"
        nerrors=$((nerrors + 1))
    fi
    
    if [[ -z ${stderr} ]]; then
        >&2 echo "ERROR: No error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi    
    
    if ! head -n 1 <<< "${stderr}" | grep -q -E "^ERROR:"; then
        >&2 echo "ERROR: Standard error output does not begin with 'ERROR:': '${stderr}'"
        nerrors=$((nerrors + 1))
    fi
    
    if ! grep -q -E "^ERROR: .*out of range.* ${level}" <<< "${stderr}"; then
        >&2 echo "ERROR: Unexpected error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi    
    
    ## Outputs nothing to stdout
    stdout=$(x86-64-level --assert="${level}" 2> /dev/null)
    if [[ -n ${stdout} ]]; then
        >&2 echo "ERROR: Detected output to standard output: ${stdout}"
        nerrors=$((nerrors + 1))
    fi
done


# x86-64-level --assert=<non-integer>
for level in 1.2 world 2=9 =; do
    echo "* x86-64-level --assert=${level} (exception)"
    stderr=$(x86-64-level --assert="${level}" 2>&1)
    exit_code=$?
    if [[ ${exit_code} -eq 0 ]]; then
        >&2 echo "ERROR: Exit code should be non-zero: ${exit_code}"
        nerrors=$((nerrors + 1))
    fi
    
    if [[ -z ${stderr} ]]; then
        >&2 echo "ERROR: No error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi    

    if ! head -n 1 <<< "${stderr}" | grep -q -E "^ERROR:"; then
        >&2 echo "ERROR: Standard error output does not begin with 'ERROR:': '${stderr}'"
        nerrors=$((nerrors + 1))
    fi    

    if ! grep -q -E "^ERROR: .*does not specify an integer.* ${level}" <<< "${stderr}"; then
        >&2 echo "ERROR: Unexpected error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi    
    
    ## Outputs nothing to stdout
    stdout=$(x86-64-level --assert="${level}" 2> /dev/null)
    if [[ -n ${stdout} ]]; then
        >&2 echo "ERROR: Detected output to standard output: ${stdout}"
        nerrors=$((nerrors + 1))
    fi
done


# x86-64-level <unknown option>
for option in --foo=1 --ass--ert=2 --assert--=2 --bar; do
    echo "* x86-64-level ${option} (exception)"
    stderr=$(x86-64-level "${option}" 2>&1)
    exit_code=$?
    if [[ ${exit_code} -eq 0 ]]; then
        >&2 echo "ERROR: Exit code should be non-zero: ${exit_code}"
        nerrors=$((nerrors + 1))
    fi

    if [[ -z ${stderr} ]]; then
        >&2 echo "ERROR: No error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    if ! head -n 1 <<< "${stderr}" | grep -q -E "^ERROR:"; then
        >&2 echo "ERROR: Standard error output does not begin with 'ERROR:': '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    if ! grep -q -F "ERROR: Unknown option: ${option}" <<< "${stderr}"; then
        >&2 echo "ERROR: Unexpected error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    ## Outputs nothing to stdout
    stdout=$(x86-64-level "${option}" 2> /dev/null)
    if [[ -n ${stdout} ]]; then
        >&2 echo "ERROR: Detected output to standard output: ${stdout}"
        nerrors=$((nerrors + 1))
    fi
done


# x86-64-level --assert=''
echo "* x86-64-level --assert='' (exception)"
stderr=$(x86-64-level --assert="" 2>&1)
exit_code=$?
if [[ ${exit_code} -eq 0 ]]; then
    >&2 echo "ERROR: Exit code should be non-zero: ${exit_code}"
    nerrors=$((nerrors + 1))
fi

if [[ -z ${stderr} ]]; then
    >&2 echo "ERROR: No error message: '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

if ! head -n 1 <<< "${stderr}" | grep -q -E "^ERROR:"; then
    >&2 echo "ERROR: Standard error output does not begin with 'ERROR:': '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

if ! grep -q -E "^ERROR: .*must not be empty" <<< "${stderr}"; then
    >&2 echo "ERROR: Unexpected error message: '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

## Outputs nothing to stdout
stdout=$(x86-64-level --assert="" 2> /dev/null)
if [[ -n ${stdout} ]]; then
    >&2 echo "ERROR: Detected output to standard output: ${stdout}"
    nerrors=$((nerrors + 1))
fi


echo "* x86-64-level - <<< '' (exception)"
stderr=$(x86-64-level - <<< '' 2>&1)
exit_code=$?
if [[ ${exit_code} -eq 0 ]]; then
    >&2 echo "ERROR: Exit code is not non-zero: ${exit_code}"
    nerrors=$((nerrors + 1))
fi

if [[ -z ${stderr} ]]; then
    >&2 echo "ERROR: No error message: '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

if ! head -n 1 <<< "${stderr}" | grep -q -E "^ERROR:"; then
    >&2 echo "ERROR: Standard error output does not begin with 'ERROR:': '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

if ! grep -q -E "^ERROR: .*Input data is empty" <<< "${stderr}"; then
    >&2 echo "ERROR: Unexpected error message: '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

## Outputs nothing to stdout
stdout=$( x86-64-level - <<< '' 2> /dev/null )
if [[ -n ${stdout} ]]; then
    >&2 echo "ERROR: Detected output to standard output: ${stdout}"
    nerrors=$((nerrors + 1))
fi


# x86-64-level - <<< <no or empty 'flags' entry>
inputs=("model name: Fake CPU" "flags:" "flags:   ")
for input in "${inputs[@]}"; do
    echo "* x86-64-level - <<< '${input}' (exception)"
    stderr=$(x86-64-level - <<< "${input}" 2>&1)
    exit_code=$?
    if [[ ${exit_code} -eq 0 ]]; then
        >&2 echo "ERROR: Exit code should be non-zero: ${exit_code}"
        nerrors=$((nerrors + 1))
    fi

    if [[ -z ${stderr} ]]; then
        >&2 echo "ERROR: No error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    if ! head -n 1 <<< "${stderr}" | grep -q -E "^ERROR:"; then
        >&2 echo "ERROR: Standard error output does not begin with 'ERROR:': '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    if ! grep -q -F "ERROR: No CPU 'flags' entry" <<< "${stderr}"; then
        >&2 echo "ERROR: Unexpected error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    ## Outputs nothing to stdout
    stdout=$(x86-64-level - <<< "${input}" 2> /dev/null)
    if [[ -n ${stdout} ]]; then
        >&2 echo "ERROR: Detected output to standard output: ${stdout}"
        nerrors=$((nerrors + 1))
    fi
done


echo "* x86-64-level - <<< 'flags: AVX' (exception)"
stderr=$(x86-64-level - <<< 'flags: AVX' 2>&1)
exit_code=$?
if [[ ${exit_code} -eq 0 ]]; then
    >&2 echo "ERROR: Exit code is not non-zero: ${exit_code}"
    nerrors=$((nerrors + 1))
fi

if [[ -z ${stderr} ]]; then
    >&2 echo "ERROR: No error message: '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

if ! head -n 1 <<< "${stderr}" | grep -q -E "^ERROR:"; then
    >&2 echo "ERROR: Standard error output does not begin with 'ERROR:': '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

if ! grep -q -E "^ERROR: .*format of the CPU flags" <<< "${stderr}"; then
    >&2 echo "ERROR: Unexpected error message: '${stderr}'"
    nerrors=$((nerrors + 1))
fi    

## Outputs nothing to stdout
stdout=$( x86-64-level - <<< 'flags: AVX' 2> /dev/null )
if [[ -n ${stdout} ]]; then
    >&2 echo "ERROR: Detected output to standard output: ${stdout}"
    nerrors=$((nerrors + 1))
fi


# x86-64-level --assert=<level> - <<< <invalid input>
inputs=("model name: Fake CPU" "flags:" "flags: AVX")
for input in "${inputs[@]}"; do
    echo "* x86-64-level --assert=1 - <<< '${input}' (exception)"
    stderr=$(x86-64-level --assert=1 - <<< "${input}" 2>&1)
    exit_code=$?
    if [[ ${exit_code} -eq 0 ]]; then
        >&2 echo "ERROR: Exit code should be non-zero: ${exit_code}"
        nerrors=$((nerrors + 1))
    fi

    if [[ -z ${stderr} ]]; then
        >&2 echo "ERROR: No error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    ## Reports on the invalid input, and not on a failed assertion
    if ! head -n 1 <<< "${stderr}" | grep -q -E "^ERROR:"; then
        >&2 echo "ERROR: Standard error output does not begin with 'ERROR:': '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    if grep -q -F "which is less than the required" <<< "${stderr}"; then
        >&2 echo "ERROR: Reports on a failed assertion, and not on the invalid input: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    ## Reports the error once, i.e. does not continue after the failure
    if [[ $(wc -l <<< "${stderr}") -ne 1 ]]; then
        >&2 echo "ERROR: Expected a single error message: '${stderr}'"
        nerrors=$((nerrors + 1))
    fi

    ## Outputs nothing to stdout
    stdout=$(x86-64-level --assert=1 - <<< "${input}" 2> /dev/null)
    if [[ -n ${stdout} ]]; then
        >&2 echo "ERROR: Detected output to standard output: ${stdout}"
        nerrors=$((nerrors + 1))
    fi
done


#--------------------------------------------------------------------------
# Summary
#--------------------------------------------------------------------------
if [[ ${nerrors} -eq 0 ]]; then
    echo "x86-64-level ... DONE"
else
    echo "Number of ERRORS: ${nerrors}"
    echo "x86-64-level ... ERROR"
    exit 1
fi

