#! /bin/bash

# cannot `set -u` here because `if [ -z "$BATS_PREFIX_LIST" ];` errors
## if we enforce bash version 4.2 then we can use `if [ -v BATS_PREFIX_LIST ]` to check
## and then can `set -u` here 
set -e

OTHER_TYPES=( 'feat' 'fix' 'bugfix' 'perf' 'test' )

# set directory for calling other scripts
# NOTE: expect this to be called in this directory
DIR=$(dirname "${BASH_SOURCE[0]}")

main() {

  # get allowed names from labels.yaml
  # shellcheck disable=SC2207
  LABEL_TYPES=( $(less "$DIR"/../../../.github/labels.yaml | sed -n "/name/p" | sed "s/- name: \"//" | sed "s/\"//" | sed -n "/^[a-z]*$/p") )

  # merge labels.yaml with hardcoded
  local PREFIXES=( "${LABEL_TYPES[*]}" "${OTHER_TYPES[*]}" )

  echo "${PREFIXES[*]}"

}

## For BATS testing
mock() {
  echo "$BATS_PREFIX_LIST"
}

if [ -z "$BATS_PREFIX_LIST" ]; then
  main
else
  mock
fi
