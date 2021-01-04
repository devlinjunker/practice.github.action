---
Version: 0.2-SNAPSHOT
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

This is an example project with a goal of 100% passing [Core Infrastructure Initiative Criteria] status. It is based off of the [Github Semver Project](https://github.com/devlinjunker/template.github.semver) Template. 

Contains the following improvements for passing status:
- Automated Test Suite (for Bash Scripts)
- Static Code Analysis (Linting)


## Dependencies/Frameworks
<!-- List the frameworks, libraries, and tools the project uses: -->

- [Bulldozer] - Github Application to Auto Squash and Merge feature PRs
- [Git-mkver] - Binary that helps with determining next semantic version based on Git Tags
- [BATS] - Automated Test Suite for Bash Scripts
- [ShellCheck] - Linting Tool for Bash Scripts

## Quick Setup/Run
<!-- This section should try to quickly explain how to setup the project and start using it (server/app/demo/template) - ideally in list format -->
 
 <!-- - [ ] Review the [Wiki] - overview of the concepts -->
 - [ ] [Clone or Template to New Project][Contributing Guide]
 - [ ] Review/Update [License] File
 - [ ] Review/Update [Security Policy]
   - Provide private way of reporting vulnerabilities?
 - [ ] Update this README and Links with project specific details
 - [ ] Review [Github Workflows] in Template (and improve for your process)
 - [ ] Add Custom Project Build and Configuration Files
 - Start Writing Tests and Coding!

## Links

- [Code of Conduct]
- [Contributing Guide]
- [Security Policy]
<!-- - [Wiki] -->
- External
  - [Core Infrastructure Initiative Criteria]

## Contributors

- [Devlin Junker (Me!)](mailto:devlinjunker@gmail.com)



[License]: LICENSE
[Security Policy]: SECURITY.md
[Code of Conduct]: CODE_OF_CONDUCT.md
[Contributing Guide]: CONTRIBUTING.md
[Git Hooks]: scripts/hooks#git-hook-scripts
[Github Workflows]: .github/workflows#github-workflows
[Core Infrastructure Initiative Criteria]: https://bestpractices.coreinfrastructure.org/en/criteria/0
[Bash]: https://tldp.org/LDP/abs/html/
[Github Actions]: https://docs.github.com/en/free-pro-team@latest/actions
[Bulldozer]: https://github.com/palantir/bulldozer
[Git-mkver]: https://idc101.github.io/git-mkver/
[BATS]: https://bats-core.readthedocs.io/
[ShellCheck]: https://www.shellcheck.net/