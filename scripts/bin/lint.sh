#! /bin/bash

# cannot `set -u` here because `if [[ -z "$BATS_TMPDIR" ]];` errors
## if we enforce bash version 4.2 then we can use `if [ -v BATS_TMPDIR ]` to check
## and then can `set -u` here 
set -e

DIR=$(dirname "$0")

lint_scripts() {
    if [[ ! -f "$DIR/../../lib/shellcheck*/" ]]; then
        pushd "$DIR"/../../lib/ || exit
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            tar -xf shellcheck*linux*.tar*
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            tar -xf shellcheck*darwin*.tar*
        else
            echo "Error: OS not supported ($OSTYPE)"
            exit 1
        fi
        popd || exit
    fi

    files=$(find "$DIR"/../../scripts/**/*.sh -name '*.sh')

    for f in ${files[*]}
    do
        echo "$f"
        # shellcheck disable=SC2211,SC2046
        "$DIR"/../../lib/shellcheck*/shellcheck "$f"
    done

    
}


main() {
    # skip if in test (avoid infinite loop)
    if [[ -z $BATS_TMPDIR ]]; then
        lint_scripts
    else
        echo "RUNNING_LINTS"
    fi
}

main "$@"