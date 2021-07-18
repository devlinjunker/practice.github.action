# Developer Scripts

The scripts in this directory should be used by developers, they can help with development tasks that require multiple processes and are easier automated.

This includes:

## lint.sh
- Runs the linting programs to ensure the style guide is met

## test.sh
- Runs the test files to prevent regressions
    - run all tests if no arguments are passed (or `-a/--all`)
    - or will try to find a specific file to run with the `-f/--file` argument