## Testing

The `qa/` directory contains files used during testing. It is named "qa" so that it will precede the `script/` and `src/` directories that it will be testing in Pull Requests.

Each feature that is added to this project should include test files that detail the expectations for the new feature. If there is a new unit testing framework needed, please [submit an issue](https://github.com/devlinjunker/example.cii/issues/new/choose).

For now this includes:
 - unit tests with BATS for script files

## Other Ideas
 - integration tests
 - e2e tests
 - automation tests
 - contract tests
 - mutation tests
 - helpers?
    - BATS helper - mocking/stubbing/spying (see [here](scripts/release/release-prep-upmerge.bats))