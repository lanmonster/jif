#!/bin/bash

TESTS=(
    "sample1"
    "sample2"
    "jf"
    "ghost"
    "dancing"
)

function print_tests {
    PREV_IFS=$IFS
    IFS=,
    printf "${TESTS[*]}"
    IFS=$PREV_IFS
}

function usage {
    printf "Usage: meta/run.sh <test>\n"
    printf "\tTests: "
    print_tests
    echo
}

is_valid=false
for test in ${TESTS[@]}; do
    if [[ $test == $1 ]]; then
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

jakt jif.jakt 2>/dev/null && build/jif tests/$TESTNAME/$TESTNAME.gif "$@"
