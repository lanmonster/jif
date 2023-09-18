#!/bin/bash


TESTS=(
    "sample1"
    "sample2"
    "jf"
    "ghost"
    "dancing"
)
FIELDS=(
    "codestream"
    "codetable"
)

function print_tests {
    PREV_IFS=$IFS
    IFS=,
    printf "${TESTS[*]}"
    IFS=$PREV_IFS
}

function print_fields {
    PREV_IFS=$IFS
    IFS=,
    printf "${FIELDS[*]}"
    IFS=$PREV_IFS
}

function usage {
    printf "Usage: meta/test.sh <test> <field>\n"
    printf "\tTests: "
    print_tests
    printf "\n\tFields: "
    print_fields
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
is_valid=false
for field in ${FIELDS[@]}; do
    if [[ $field == $2 ]]; then
        is_valid=true
        break
    fi
done
if ! $is_valid; then
    usage
    exit 1
fi

jakt jif.jakt 2>/dev/null && build/jif tests/$1/$1.gif --debug-$2 tests/$1/$2.txt ; diff tests/$1/expected-$2.txt tests/$1/$2.txt && echo "SUCCESS"