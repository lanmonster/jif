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

if [[ $# == 0 ]]; then
    TESTNAME="meta/test.sh $test $field"
    echo "building once"
    jakt jif.jakt 2>/dev/null
    if [[ $? != 0 ]]; then
        echo "$TESTNAME => FAIL. Could not compile"
        : > tests/$1/$2.txt
        exit 0
    fi
    for test in ${TESTS[@]}; do
        for field in ${FIELDS[@]}; do
            meta/test.sh $test $field --no-build
        done
    done
    exit 0
fi

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

: > tests/$1/$2.txt

TESTNAME="meta/test.sh $test $field"

if [[ ! $@ =~ "--no-build" ]]; then
  jakt jif.jakt 2>/dev/null
    if [[ $? != 0 ]]; then
        echo "$TESTNAME => FAIL. Could not compile"
        : > tests/$1/$2.txt
        exit 0
    fi
fi


build/jif tests/$1/$1.gif --debug-$2 tests/$1/$2.txt 2>/dev/null 1>/dev/null
if [[ $? != 0 ]]; then
    echo "$TESTNAME => FAIL. Could not run"
    : > tests/$1/$2.txt
    exit 0
fi

diff tests/$1/expected-$2.txt tests/$1/$2.txt > tests/$1/$2.diff
if [[ $? != 0 ]]; then
    echo "$TESTNAME => FAIL. Different results"
    : > tests/$1/$2.txt
    exit 0
fi

echo "$TESTNAME => PASS"
: > tests/$1/$2.txt