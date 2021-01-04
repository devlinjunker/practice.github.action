#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/workflows

TEST_PREFIX="branch-match.sh -";

@test "$TEST_PREFIX should pass if BRANCH matches REGEXP" {
    BRANCH="test-abc"
    REGEXP="test"
    export BRANCH
    export REGEXP

    run "$SCRIPT_DIR"/branch-match.sh

    unset BRANCH
    assert_success
}

@test "$TEST_PREFIX should error if BRANCH does not match REGEXP" {
    BRANCH="-abc"
    REGEXP="test"
    export BRANCH
    export REGEXP

    run "$SCRIPT_DIR"/branch-match.sh

    unset BRANCH
    assert_failure
}