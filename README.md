# Installing protostar

## Unix

Open shell and run:

`curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash`

Ensure your profile file has protostar included.

For me it added it to added it manually.

Open bash configuration file by running:

`nano ~/.bash_profile`

Append this to the file and save:

`export PATH="~/.protostar/dist/protostar"`

Save

Load the changes:

`source ~/.bash_profile`

# Running compliance tests

From within the main repo directory run:

`protostar test test/<TEST_TO_RUN>.cairo`

So running example 1 would be:

`protostar test test/test_ex1.cairo`

All tests should pass without any modifaction of the tests files.

You **MUST** only modify the `.cairo` files in the `/exercises/` directory.

# ERC20 contract

This is a contractr that inherits from the base ERC20 implementation.

There are several features that need to be added to improve it.

Tests will run against any implementations.

To run the test file invoke:

`protostar test test/test_erc20.cairo`

Since nothing is done, hopefully all tests will fail.

You should modify **ONLY** the file `erc20.cairo` in `exercises/contracts/`.

If feature is complete run again

`protostar test test/test_erc20.cairo`

Functions that need to be implemnted are specified in the `@contract_interface` in `test_erc20.cairo`.

## Features to implement

### Even transfer

Already implemted `transfer()` is a bit boring so modify such that it only allows transfers of even amounts of Erc20.

### Faucet

Users may require some of the test tokens for development.

Implement a funcion `faucet()` that will hand out a number of tokens to the caller.

As tokens are (potentially) valuable, cap the maximum amount to be minted and transfered per invocation to 10,000.

### Burn haircut

Sometimes tokens need to be burned, but there is no reason not to keep some as the contract deployer.

Implement a funcion `burn()` that will:

- take 10% of the amount to be burned and send to the address of the deployer/admin
- burn the rest

### Exclusive faucet

You need to implement three functions:

#### `request_whitelist()`

This function will set in the mapping (which needs to be implemented using the `@storage_var` decorator) value of 1 for any address that requests whitelisting

#### `check_whitelist()`

This function will check whether provided address has been whitelisted and will return:

- 1 if the caller has been whitelisted
- 0 if the caller has not been whitelisted

#### `exclusive_faucet()`

This function will accept an amount to be minted, it will then check if the caller has been whitelisted using `check_whitelist()`. If the caller has been whitelisted it will mint any amount that the caller asks for.

# TODO

1. Change dir name so its capital or different than the file
2. Capitalise startr lines
3. Do TODOs
4. Revert to base imports
