#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../../lib/bats-support/load'
load '../../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../../scripts/hooks/internal
TEST_PREFIX="branch-protections.sh -";

@test "$TEST_PREFIX should error on 'main' or 'develop' " {
    function git() {
        echo "main"
    }
    export -f git
    run "$SCRIPT_DIR"/branch-protections.sh

    assert_failure

    function git() {
        echo "develop"
    }
    export -f git
    run "$SCRIPT_DIR"/branch-protections.sh

    assert_failure
}

@test "$TEST_PREFIX should not error on other branches" {
    function git() {
        echo "abc"
    }
    export -f git
    run "$SCRIPT_DIR"/branch-protections.sh

    assert_success
}