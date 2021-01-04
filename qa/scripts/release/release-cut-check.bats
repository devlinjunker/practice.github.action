#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/release

TEST_PREFIX="release-cut-check.sh -";

@test "$TEST_PREFIX should error if found branch matching branch RELEASE_BRANCH" {
    RELEASE_BRANCH='abc'
    export RELEASE_BRANCH;
    function git() {
        echo "abc
        123
        test"
    }
    export -f git

    run "$SCRIPT_DIR"/release-cut-check.sh

    assert_failure
}

@test "$TEST_PREFIX should NOT error if cannot find branch matching RELEASE_BRANCH" {
    RELEASE_BRANCH='abc'
    export RELEASE_BRANCH;
    function git() {
        echo "xyz
        123
        test"
    }
    export -f git

    run "$SCRIPT_DIR"/release-cut-check.sh

    assert_success
}