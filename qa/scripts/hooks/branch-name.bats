#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/hooks

TEST_PREFIX="branch-name.sh -";


@test "$TEST_PREFIX should not allow branches that don't match output of prefix-list.sh or defaults" {
    function git() {
        echo "abc/test-name";
    }
    export -f git

    BATS_PREFIX_LIST=""
    export BATS_PREFIX_LIST
    
    run "$SCRIPT_DIR"/branch-name.sh
    unset BATS_PREFIX_LIST

    assert_failure
}

@test "$TEST_PREFIX should allow default branch prefixes (feat, fix)" {
    function git() {
        echo "fix/test-name";
    }
    export -f git

    run "$SCRIPT_DIR"/branch-name.sh

    assert_success

    function git() {
        echo "feat/test-name";
    }
    export -f git

    run "$SCRIPT_DIR"/branch-name.sh

    assert_success
}

@test "$TEST_PREFIX should allow branches that match output of prefix-list.sh" {
    function git() {
        echo "abc/test-name";
    }
    export -f git
    
    BATS_PREFIX_LIST="abc"
    export BATS_PREFIX_LIST

    run "$SCRIPT_DIR"/branch-name.sh
    unset BATS_PREFIX_LIST

    assert_success
}

@test "$TEST_PREFIX should allow patch branches" {
    function git() {
        echo "patch-0.0.1"
    }
    export -f git

    run "$SCRIPT_DIR"/branch-name.sh
    assert_success
}