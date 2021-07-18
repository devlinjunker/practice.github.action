#! /bin/bash

# set directory for calling other scripts
DIR=$(dirname "${BASH_SOURCE[0]}")

# if in hook, then prep PATH to find in repo `scripts/hooks/` dir
# shellcheck disable=SC2076
if [[ $DIR =~ ".git" ]]; then
  DIR+="/../../scripts/hooks"
fi


BRANCH_NAME_ERROR=" !  Branch name does not match conventions  "

main() {

  # Call branch name script
  if ! $DIR/internal/branch-name.sh; then
    echo "$(tput setaf 1)$(tput setab 7)$BRANCH_NAME_ERROR$(tput sgr 0)"
    echo "  <prefix>/<description>"
    echo "prefix options: ($($DIR/internal/prefix-list.sh -o))"
    return 1;
  fi

  # Test if last commit message starts with `wip`
  message=$(git log --pretty=format:"%s" -1)

  if [[ "$message" != "wip"* ]]; then
    git stash save -k "githook uncommitted changes" > /dev/null;

    if ! $DIR/../bin/lint.sh; then
      git stash pop;
      return 1;
    fi


    if ! $DIR/../bin/test.sh; then
      git stash pop;
      return 1;
    fi

    git stash pop || true;
  fi
}

main

