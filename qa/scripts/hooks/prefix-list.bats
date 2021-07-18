#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/hooks/internal
TEST_PREFIX="prefix-list.sh -";

@test "$TEST_PREFIX should output default list of allowed branches" {
    function less() {
        echo ''
    }
    export -f less
    run "$SCRIPT_DIR"/prefix-list.sh
    
    unset less
    
    assert_output --partial 'feat'
    assert_output --partial 'fix'
}

@test "$TEST_PREFIX should include values from labels file" {
    function less() {
        echo '- name: "abc"'
    }
    export -f less

    run "$SCRIPT_DIR"/prefix-list.sh
    unset less

    assert_output --partial 'abc'
}

@test "$TEST_PREFIX should use BATS_PREFIX_LIST if set (for mocking tests)" {
    BATS_PREFIX_LIST='abc 123'
    export BATS_PREFIX_LIST;

    run "$SCRIPT_DIR"/prefix-list.sh
    unset less

    assert_output 'abc 123'
}