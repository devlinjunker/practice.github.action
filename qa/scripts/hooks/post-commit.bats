#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/hooks
TEST_PREFIX="post-commit.sh -";

@test "$TEST_PREFIX should show warning if over 25 files or 400 lines" {
    function sed() {  # branch to compare
        echo "develop"
    }
    export -f sed
    function tail () { ## lines
        echo "401"
    }
    function head () { ## files
        echo "24"
    }
    export -f tail
    export -f head

    run "$SCRIPT_DIR"/post-commit.sh

    unset sed
    assert_output --partial "warning"

    function sed() { # branch to compare
        echo "develop"
    }
    export -f sed
    function tail () { ## lines
        echo "399"
    }
    function head () { ## files
        echo "26"
    }
    export -f tail
    export -f head
    
    run "$SCRIPT_DIR"/post-commit.sh

    unset sed
    assert_output --partial "warning"
}

@test "$TEST_PREFIX should not show warning if under 25 files and 400 lines" {
    function sed() { # branch to compare
        echo "develop"
    }
    export -f sed
    function tail () { ## lines
        echo "399"
    }
    function head () { ## files
        echo "19"
    }
    export -f tail
    export -f head

    run "$SCRIPT_DIR"/post-commit.sh

    unset sed

    assert_output
}