# Script Files
This directory contains script files to help with developer workflows, for now these are shell scripts. But if desired, we could replace these with node or python scripts instead.

## Conventions
  - Add `set -eu` to top of shell scripts when possible
    - `set -e` causes the script to exit if any errors occur
    - `set -u` causes the script to error if any undeclared variables are encountered
  - Linting with [Shellcheck] for ideal formatting to prevent errors
  - Unit Testing with [BATS] (Bash Automatic Testing System)
  - Ideally wrap code in `main` method and then invoke at the end of script


[ShellCheck]: https://www.shellcheck.net/
[BATS]: https://bats-core.readthedocs.io/