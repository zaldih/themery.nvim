# Development Practices for Themery.nvim

This document outlines the development practices, including testing, for the Themery.nvim project.

## Running Unit Tests

To ensure the quality and functionality of Themery.nvim, unit tests have been implemented. These tests are located in the `tests/` directory of the repository.

To run the unit tests, you will need to have a Lua testing framework installed, such as Busted or Luassert. Once you have a testing framework installed, you can run the tests by executing the following command from the root of the repository:

```bash
busted ./tests/
```

This command will run all the tests found in the `tests/` directory and output the results. It's recommended to run the tests before pushing changes to ensure that your contributions do not introduce regressions or break existing functionality.
