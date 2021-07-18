---
Version: 0.4-SNAPSHOT
---

# Example - CII 100%
<!-- Find More Badges Here: https://shields.io/ -->

[![GitHub License](https://img.shields.io/github/license/devlinjunker/example.cii?color=blue)](https://github.com/devlinjunker/example.cii/blob/develop/LICENSE)  
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/devlinjunker/example.cii)](https://github.com/devlinjunker/example.cii/releases)
[![GitHub last commit](https://img.shields.io/github/last-commit/devlinjunker/example.cii)](https://github.com/devlinjunker/example.cii/commits/main)  
[![CII Best Practices Summary](https://img.shields.io/cii/summary/4558?label=core-infrastructure)](https://bestpractices.coreinfrastructure.org/en/projects/4558)  
[![GitHub issues](https://img.shields.io/github/issues/devlinjunker/example.cii)](https://github.com/devlinjunker/example.cii/issues)
[![GitHub priority issues](https://img.shields.io/github/issues/devlinjunker/example.cii/-priority?color=red&label=priority%20issues)](https://github.com/devlinjunker/example.cii/issues?q=is%3Aopen+is%3Aissue+label%3A-priority)


## Intro
<!-- Quick Description, could match Github repo description or have a little more info-->

This is an example project with a goal of 100% passing [Core Infrastructure Initiative Criteria] status. It is based off of the [GitHub Semver Project] Template. 

Contains the following improvements for passing status:
- Automated Test Suite (for Bash Scripts)
- Static Code Analysis (Linting)

Also contains:
- [PR Landmine Action]


## Dependencies/Frameworks
<!-- List the frameworks, libraries, and tools the project uses: -->

- [Bulldozer] - Github Application to Auto Squash and Merge feature PRs
- [Git-mkver] - Binary that helps with determining next semantic version based on Git Tags
- [BATS] - Automated Test Suite for Bash Scripts
- [ShellCheck] - Linting Tool for Bash Scripts
- [PR Landmine Action] - Mutation Testing Pull Requests

## Quick Setup/Run
<!-- This section should try to quickly explain how to setup the project and start using it (server/app/demo/template) - ideally in list format -->

 - [ ] Review [Wiki]
    - [FAQ]
    - [README Pages]
 - [ ] Review documentation in [GitHub Semver Project]
 - [ ] Clone repo (with submodules)
    - `git clone --recurse-submodules --remote-submodules https://github.com/devlinjunker/example.cii.git`
    - If forking to a new project, follow the [Steps for New Project] before adding new code

### Add Code
 - [ ] Create branch matching style `<prefix>/<hyphenated-description>`
 - [ ] Add changes to branch
 - [ ] Before push, if hooks are installed, should do the following (otherwise manual):
    - [ ] Run bash linting with `./scripts/bin/lint.sh`
    - [ ] Run all unit tests with `./scripts/bin/test.sh`
 - [ ] Create Pull Request against `develop`


### Create Release
See full details in the Github Semver Project [wiki](https://github.com/devlinjunker/template.github.semver/wiki/Release)
 - **Must be after `feature/*` or `feat/*` branch is merged**
 - [ ] Initiate `release-cut` GitHub Action
 - [ ] Merge the created `release-*` PR to `main` to start release
    - **Avoid `squash and merge`**


## Links

- [Code of Conduct]
- [Contributing Guide]
- [Security Policy]
- [Wiki]
  - [FAQ]
  - [README Pages]
- External
  - [Core Infrastructure Initiative Criteria]
  - [BATS]
  - [ShellCheck]
  - [PR Landmine Action]

## Contributors

- [Devlin Junker (Me!)](mailto:devlinjunker@gmail.com)



[License]: LICENSE
[Security Policy]: SECURITY.md
[Code of Conduct]: CODE_OF_CONDUCT.md
[Contributing Guide]: CONTRIBUTING.md
[Git Hooks]: scripts/hooks#git-hook-scripts
[Github Workflows]: .github/workflows#github-workflows
[Wiki]: https://github.com/devlinjunker/example.cii/wiki
[FAQ]: https://github.com/devlinjunker/example.cii/wiki/!-FAQ
[README Pages]: https://github.com/devlinjunker/example.cii/wiki/.README-(synced)
[Steps for New Project]: https://github.com/devlinjunker/template.github.semver#steps-for-new-project
[Core Infrastructure Initiative Criteria]: https://bestpractices.coreinfrastructure.org/en/criteria/0
[Bash]: https://tldp.org/LDP/abs/html/
[Github Actions]: https://docs.github.com/en/free-pro-team@latest/actions
[Bulldozer]: https://github.com/palantir/bulldozer
[Git-mkver]: https://idc101.github.io/git-mkver/
[BATS]: https://bats-core.readthedocs.io/
[ShellCheck]: https://www.shellcheck.net/
[GitHub Semver Project]: https://github.com/devlinjunker/template.github.semver#intro
[PR Landmine Action]: https://github.com/tylermurry/github-pr-landmine
