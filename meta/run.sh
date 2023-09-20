#!/bin/bash

# shellcheck disable=SC2207
TESTS=( $(find tests -type d -depth 1 -exec basename {} \; ) )

function print_tests {
    PREV_IFS=$IFS
    IFS=,
    printf "%s" "${TESTS[*]}"
    IFS=$PREV_IFS
}

function usage {
    printf "Usage: meta/run.sh <test>\n"
    printf "\tTests: "
    print_tests
    echo
}

is_valid=false
for test in "${TESTS[@]}"; do
    if [[ $test == "$1" ]]; then
        is_valid=true
        break
    fi
done
if ! $is_valid; then
    usage
    exit 1
fi

TESTNAME=$1
shift

jakt jif.jakt 2>/dev/null && build/jif tests/"$TESTNAME"/"$TESTNAME".gif "$@"
