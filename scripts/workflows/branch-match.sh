#! /bin/bash

set -eu

## Verify that BRANCH matches regexp, else error
if [[ ! $BRANCH =~ $REGEXP ]]; then
    exit 1;
fi