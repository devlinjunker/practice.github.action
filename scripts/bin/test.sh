#! /bin/bash

DIR=$(dirname "$0")

find_script_test() {
    "$DIR"/../../lib/bats-core/bin/bats "$@"
}

all_script_tests() {
    "$DIR"/../../lib/bats-core/bin/bats "$DIR"/../../qa/ -r
}

main() {
    case "$1" in
        --file | -f)
            find_script_test "${@: 2}"
            ;;
        --all | -a | *)
            all_script_tests
            ;;
    esac
}

main "$@"