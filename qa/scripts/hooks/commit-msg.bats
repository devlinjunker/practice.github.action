#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/hooks
TEST_PREFIX="commit-msg.sh -";

@test "$TEST_PREFIX should allow commit messages that match basic format <prefix>:<description>" {
    BATS_PREFIX_LIST=''
    export BATS_PREFIX_LIST
    
    echo "fix: test" > tmp;

    run "$SCRIPT_DIR"/commit-msg.sh tmp
    assert_success

    echo "fix: test 123 look at me" > tmp;

    run "$SCRIPT_DIR"/commit-msg.sh tmp
    assert_success

    echo "feat: test" > tmp;

    run "$SCRIPT_DIR"/commit-msg.sh tmp
    assert_success

    echo "wip: test" > tmp;

    run "$SCRIPT_DIR"/commit-msg.sh tmp
    assert_success

    unset BATS_PREFIX_LIST
    rm tmp;
}

@test "$TEST_PREFIX should NOT allow commit messages that do not match format" {
    BATS_PREFIX_LIST=''
    export BATS_PREFIX_LIST
    
    echo "abctest" > tmp;

    run "$SCRIPT_DIR"/commit-msg.sh tmp
    assert_failure

    unset less
    rm tmp;
}

@test "$TEST_PREFIX should allow optional scope" {
    BATS_PREFIX_LIST=''
    export BATS_PREFIX_LIST
    
    echo "fix(scope): test" > tmp;

    run "$SCRIPT_DIR"/commit-msg.sh tmp
    assert_success

    echo "feat(scope): test" > tmp;

    run "$SCRIPT_DIR"/commit-msg.sh tmp
    assert_success

    unset BATS_PREFIX_LIST
    rm tmp;
}