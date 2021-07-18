#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/release

TEST_PREFIX="release-prep-upmerge.sh -";

## Mock git binary that stores all call args in file by line
function git() {
    echo "$@" >> $BATS_TMPDIR/git.args
}

setup() {
    export -f git
}

teardown() {
    unset git
    rm $BATS_TMPDIR/git.args
}

@test "$TEST_PREFIX should call git and merge main into develop" {
    run "$SCRIPT_DIR"/release-prep-upmerge.sh main

    first=$(sed '1q;d' $BATS_TMPDIR/git.args)
    second=$(sed '2q;d' $BATS_TMPDIR/git.args)
    third=$(sed '3q;d' $BATS_TMPDIR/git.args)

    # checkout develop and merge main into it
    assert_equal "$first" "checkout develop"
    assert_equal "$second" "pull"
    assert_equal "$third" "merge main"
}