#! /bin/bash
#  Open Versioned files in repo and increment version

set -eu

# check number of arguments first so we don't access unset variable and error with set -u
if [[ $# == 0 || -z "$1" ]]; then
    echo "Error: no version number"
    exit 1;
fi;

## README
#   - Replace first 3 lines with:

#   ---
#   Version: $1
#   ---
if [ -f ./README.md ]; then
    cp README.md README.old.md;
    
    echo "---
Version: $1
---" > README.md; 
    tail -n +4 ./README.old.md >> README.md;
    
    rm README.old.md
fi