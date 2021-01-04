## Testing Script Files

Shell Script testing is done with [BATS]. These tests are organized in the same structure as the `script/` file directory and test files will have the same name as the script they are testing.


To run every BATS test:
```
lib/bats-core/bin/bats qa -r
```

To run a single BATS test:
```
lib/bats-core/bin/bats <path to .bats file>
```


[BATS]: https://bats-core.readthedocs.io/