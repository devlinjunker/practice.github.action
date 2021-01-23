# How to Contribute!

Thanks for helping out!


## Reporting Issues
The best way to [report an issue is through Github](https://github.com/devlinjunker/example.cii/issues/new/choose). The owners of the repo should get an email notification whenever a new issue is created.


## Development 
<!-- This section details the steps to setup the project for development -->

### Environment Setup and Tools
This project has been tested on OSX Machines and uses script files that expect Bash to be installed at `/bin/bash`. 

The remaining dependencies should be downloaded when you clone the repo (with submodules for other git repos). The included archive files will be extracted before use, so there is no additional steps necessary.


### Folder Structure
Break down how each folder is used in the repo and how different code file types should be organized.

```
- .github/
|-- ISSUE_TEMPLATE/  
|---- (Github Issue Template Files)
|-- workflows/
|---- (Github workflow .yaml files)
|-- (other github specific files)
- lib/
|-- (dependency library directories and compressed archives)
- qa/
|-- scripts/
|---- files specific to testing the script files (BATS)
|-- (other testing files should be stored in here)
- scripts/
|-- bin/
|---- (Scripts for developers to run the project)
|-- hooks/
|---- (Git Hooks Scripts)
|-- release/
|---- (Script files that help with creating releases)
|-- workflows/
|---- (Github workflow Scripts)
- (project config files and READMEs)
```


### Scripts
Git hooks and Github workflows/actions are extremely useful for streamlining processes and typical developer actions, or verifying that standards are met. This section documents how they should be used in this project.


#### Hooks
Git Hooks are scripts that can be run during certain parts of the Git process (after committing, before pushing, etc). Git Hooks can be added in the `.git/hooks` directory (I prefer to create symbolic link to another place in the repo so they can be committed for every developer. e.g. store the hook scripts in `./hooks`, after git repo set up use `ln -s ./hooks/ ./.git/hooks`).

To create a hook, you add a script file (or symbolic link to one) in the `.git/hooks/` directory with the name of the hook from [this list](https://git-scm.com/docs/githooks#_hooks). (e.g. to run a script before a commit is saved -- to verify the contents of the commit, verify the app builds, etc -- you would create `./.git/hooks/pre-commit`).

[Review Hooks in this Repo](https://github.com/devlinjunker/template.github.semver/blob/main/scripts/hooks#git-hook-scripts)

#### Workflows
[GitHub Workflows/Actions](https://docs.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow) are commands that can be run on GitHub servers, these are added in `.github/workflows` and defined with YAML files that express when the workflow should run and the steps it should take. Github can enforce that these workflows are successful before Pull Requests are merged via the [Branch Settings Page](https://github.com/devlinjunker/template.github.semver/settings/branches), it can also trigger them after users perform certain actions or they can be manually triggered to run.

[Review Workflows in this Repo](https://github.com/devlinjunker/template.github.semver/blob/main/.github/workflows#github-workflows)


#### Other Scripts
Shell scripts are short programs that are created to help with small tasks. They can be a part of a workflow or hook, or they can help with  deployment/installation and running the final software product.  

[Review Scripts in this Repo](https://github.com/devlinjunker/template.github.semver/scripts/)


#### Auto-Merge with Bulldozer
This repo has a `.bulldozer.yml` file that is used to customize how to automatically merge pull requests into the `develop` branch. This is done with the [Bulldozer Github App](https://github.com/palantir/bulldozer). 

The default requirements to auto-merge are:
 1. all required status checks passing
 2. a comment matching: `!merge` or `! merge`



### Best Practices

#### Branching and Pull Requests
View the strategies outlined in our Wiki for [best practices for branching and merging new features](https://github.com/devlinjunker/template.github.semver/wiki/Branching-&-Code-Reviews), as well as steps to take when reviewing other submissions. The Git Hooks and Actions in this template are designed to encourage following these best strategies.


#### Security
Review the [Security Policy](https://github.com/devlinjunker/template.github.semver/blob/main/SECURITY.md) for an idea of how to submit bug reports and a review of security design principles to follow when contributing. 


#### Style Guide
This example uses the [Shellcheck](https://www.shellcheck.net/) command line tool to ensure that the Bash Scripts that help automate the Semantic Versioning process are written with up to date standards.

See the [Shellcheck Wiki](https://github.com/koalaman/shellcheck/wiki/Checks) for a full list of the checks that it is performing

Run the linting process with:
```
scripts/bin/lint.sh
```


#### Testing
This example includes tests for each of the Bash Scripts that help automate the Semantic Versioning process in GitHub Actions and that run during the Git Hooks. Each `.sh` file in the `scripts/` directory should have a corresponding `.bats` file in the `qa/scripts/` directory.

Run every test with:
```
qa/runner.sh
```

Run a single test with:
```
qa/runner.sh --file <path to file>
```

See the [READMEs in `qa/` directory](https://github.com/devlinjunker/example.cii/tree/develop/qa)


#### Release 
This template uses [Semantic Versioning](https://github.com/devlinjunker/template.github.semver/wiki/Release) to label each iteration of the final project. This ensures a consitent and meaningful format for numbering releases. 

Release branches are cut from the `develop` branch and merged into `main` after review. They are then tagged and marked as a release with a changelog (generated from the commit messages) of the changes made since the last release. 

This process can be improved upon in projects that use this template by:
 - Building and Adding code Artifacts to releases
 - Including Github Milestones
