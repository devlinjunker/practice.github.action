#! /bin/bash

# cannot `set -u` here because `if [[ -z "$BATS_TMPDIR" ]];` errors
## if we enforce bash version 4.2 then we can use `if [ -v BATS_TMPDIR ]` to check
## and then can `set -u` here 
set -e

DIR=$(dirname "$0")

find_script_test() {
    "$DIR"/../../lib/bats-core/bin/bats "$@"
}

all_script_tests() {
    "$DIR"/../../lib/bats-core/bin/bats "$DIR"/../../qa/ -r
}

main() {
    # skip if in test (avoid infinite loop)
    if [[ -z "$BATS_TMPDIR" ]]; then
        case "$1" in
            --file | -f)
                find_script_test "${@: 2}"
                ;;
            --all | -a | *)
                all_script_tests
                ;;
        esac
    else
        echo "RUNNING_TESTS"
    fi
}

main "$@"