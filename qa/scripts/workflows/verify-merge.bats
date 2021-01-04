#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/workflows

TEST_PREFIX="verify-merge.sh -";

@test "$TEST_PREFIX should error if BRANCH is 'poc' branch" {
    BRANCH="poc/test"
    export BRANCH

    run "$SCRIPT_DIR"/verify-merge.sh

    assert_failure
}

@test "$TEST_PREFIX should error if last commit is 'wip' " {
    BRANCH="test"
    export BRANCH

    function git() {
        echo "wip: test"
    }
    export -f git

    run "$SCRIPT_DIR"/verify-merge.sh

    assert_failure
}

@test "$TEST_PREFIX should pass if above are NOT true" {
    BRANCH="test"
    export BRANCH

    function git() {
        echo "feat: test"
    }
    export -f git

    run "$SCRIPT_DIR"/verify-merge.sh

    assert_success
}