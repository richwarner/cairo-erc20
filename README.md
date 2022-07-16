# Installing protostar

# Unix

Open shell and run:

`curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash`

Ensure your profile file has protostar path included.

For me installation script failed at it and it had to be added manually.

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

**All tests should pass without any modification of the test files.**

**Hence you must only modify the `.cairo` files in the `/exercises/` directory.**

# ERC20 contract

This is a contract that inherits from the base ERC20 implementation.

Several features need to be added to improve existing functionality.

Tests will run against any implementations.

To run the test file, invoke:

`protostar test test/test_erc20.cairo`

Since nothing is done, hopefully, all tests will fail.

You should modify **ONLY** the file `erc20.cairo` in `exercises/contracts/`.

If a feature is complete, run again to see test output:

`protostar test test/test_erc20.cairo`

Functions that need to be implemented are specified in the `@contract_interface` in `test_erc20.cairo`.

## Features to implement

### Even transfer

Already implemented `transfer()` is a bit boring so modify such that it only allows for transfers of even amounts of Erc20.

### Faucet

Users may require some of the test tokens for development.

Implement function `faucet()` that will mint specified amount to the caller.

As tokens are (potentially) valuable, cap the maximum amount to be minted and transfered per invocation to 10,000.

### Burn haircut

Sometimes tokens need to be burned, but there is no reason not to keep some as the contract deployer.

Implement a funcion `burn()` that will:

- take 10% of the amount to be burned and send it to the address of the deployer/admin
- burn the rest

### Exclusive faucet

Implement a faucet that will allow to mint any amount of tokens, but only to an exclusive list.

To do that three functions are needed:

#### `request_whitelist()`

This function will set in the mapping (which needs to be implemented using the `@storage_var` decorator) value of 1 for any address that requests whitelisting.

#### `check_whitelist()`

This function will check whether the provided address has been whitelisted and will return:

- 1 if the caller has been whitelisted
- 0 if the caller has not been whitelisted

#### `exclusive_faucet()`

This function will accept an amount to be minted, it will then check if the caller has been whitelisted using `check_whitelist()`. If the caller has been whitelisted it will mint any amount that the caller asks for.

# Conversion helper

File `conversion.py` in the root directory can be used for conversion between felt and strings and numbers and uint256.

To use that helper iteratively interactively run:

`python3 -i conversion.py`
