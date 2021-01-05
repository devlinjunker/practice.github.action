#! /bin/bash

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

    # shellcheck disable=SC2211,SC2046
    "$DIR"/../../lib/shellcheck*/shellcheck $(find "$DIR"/../../scripts/**/*.sh -name '*.sh')
}


main() {
    # skip if in test (avoid infinite loop)
    if [[ -z $BATS_TMPDIR ]]; then
        lint_scripts
    fi
}

main "$@"