#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/workflows

TEST_PREFIX="collect-wiki.sh -";

setup() {
    # get full path of script
    SCRIPT_PATH=$(dirname "$SCRIPT_DIR"/collect-wiki.sh)/collect-wiki.sh

    if [ ! -z tmp ]; then 
        rm -rf tmp
    fi
    mkdir tmp
    cd tmp
}

teardown() {
    cd ..
    rm -rf tmp
}


@test "$TEST_PREFIX should create wiki/ dir with CONTRIBUTING, SECURITY and home page file" {
    echo "" > CONTRIBUTING.md
    echo "" > SECURITY.md

    $SCRIPT_PATH

    # expect wiki/ to exist
    run ls wiki
    assert_success

    # expect 3 files (home page + CONTRIBUTING and SECURITY)
    output=$(ls -A1q wiki | wc -l | tr -d ' ')
    assert_equal "$output" "3"
}

@test "$TEST_PREFIX should fail if no CONTRIBUTING or SECURITY file" {
    run $SCRIPT_PATH
    
    assert_failure
}

@test "$TEST_PREFIX should include other README files in wiki/ dir and home page" {
    echo "" > CONTRIBUTING.md
    echo "" > SECURITY.md
    mkdir test
    echo "" > test/README.md

    $SCRIPT_PATH

    # expect 4 files
    output=$(ls -A1q wiki | wc -l | tr -d ' ')
    assert_equal "$output" "4"

    run grep 'CONTRIBUTING.md' wiki/.README-\(synced\).md 
    assert_success

    run grep 'SECURITY.md' wiki/.README-\(synced\).md 
    assert_success

    run grep 'test/README.md' wiki/.README-\(synced\).md 
    assert_success
} 

@test "$TEST_PREFIX should NOT include other markdown files in wiki/ dir" {
    echo "" > CONTRIBUTING.md
    echo "" > SECURITY.md
    echo "" > TEST.md

    $SCRIPT_PATH

    # expect 3 files
    output=$(ls -A1q wiki | wc -l | tr -d ' ')
    assert_equal "$output" "3"
}