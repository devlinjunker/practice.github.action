#!/usr/bin/env ../../..libs/bats/bin/bats
load '../../../lib/bats-support/load'
load '../../../lib/bats-assert/load'

SCRIPT_DIR="$BATS_TEST_DIRNAME"/../../../scripts/release

TEST_PREFIX="update-versions.sh -";

@test "$TEST_PREFIX should error if no args passed" {
    run "$SCRIPT_DIR"/update-versions.sh
    
    assert_failure
    assert_output --partial 'Error'
}

@test "$TEST_PREFIX should update version number in README file with argument" {
    # get full path of script
    SCRIPT_PATH=$(dirname "$SCRIPT_DIR"/update-versions.sh)/update-versions.sh

    # go to tmp
    mkdir tmp
    cd tmp
    
    # create README.md file
    echo "---
Version: 1.2.3
---" > README.md

    # run script
    $SCRIPT_PATH "0.0.1"

    # expect README.md updated
    output=$(cat README.md | grep "0.0.1" | wc -l | tr -d ' ')
    assert_equal "$output" "1"
    
    # expect no other files?
    output=$(ls -1q | wc -l | tr -d ' ')
    assert_equal "$output" "1"

    cd ..
    rm -rf tmp
}