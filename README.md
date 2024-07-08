# Understanding Test Scripts

To run your test scripts, use the command `forge test`. This will compile the code in the `test` directory, execute the test functions, and compare the results to ensure they match the expected outcomes.

## Writing Test Contracts

In Solidity, the convention for writing test contracts involves creating a function called `setUp()`. This is akin to creating the `run()` function when executing scripts.

When debugging tests, you can utilize `console.log()` from `Test.sol` to print results to the terminal, similar to using `console.log()` in JavaScript.

## Ownership and Function Hierarchy

It's crucial to understand the ownership hierarchy when running test scripts. The owner of the functions in the real contract becomes the test contract. The hierarchy is as follows:

### US -> TestContract -> Function/Variable in the contract


This means `msg.sender` is not `US`, but rather the test contract. To match `msg.sender`, you can use the `this` keyword, which refers to the test contract.

## Removing Hardcoded Addresses

To streamline testing, we've eliminated the need to manually change the `AggregatorV3Interface` address in the tests.

Here's what we have done:
- Created a function `run` that returns the contract type `FundMe` when called.
- Declared a variable of type `Contract FundMe` named `fundMe`.
- Ensured it returns the address of the `AggregatorV3Interface`.

## Mock Contracts Using `helperconfig`

1. **Deploy Mocks on Local Chains:**
   - When running a local Anvil chain, deploy mock contracts.
   
2. **Track Contract Addresses Across Chains:**
   - Different chains (e.g., Sepolia ETH/USD vs. mainnet ETH/USD) have different contract addresses.
   - By setting this up correctly, you can work seamlessly with both local and multiple chains.


## Testing Scripts

To run your test scripts, use the command `forge test`. This command compiles the code in the `test`
directory, executes the test functions, and compares the results to ensure they match the expected
outcomes.

## Writing Test Contracts

When writing test contracts, it's important to understand the ownership hierarchy. The owner of
the functions in the real contract becomes the test contract. To match `msg.sender`, you can use
the `this` keyword, which refers to the test contract.

## Mock Contracts

To streamline testing, we have eliminated the need to manually change the `AggregatorV3Interface`
address in the tests. This is done by deploying mock contracts on local chains. Additionally, we
track contract addresses across chains to work seamlessly with both local and multiple chains.

# Foundry CheatCode Guide

## Foundry CheatCodes

Foundry provides a variety of cheatcodes to enhance your testing experience. One particularly useful cheatcode is `prank`. This cheatcode allows you to simulate actions from different addresses, enabling you to track who is performing what actions in your tests. This is especially beneficial when dealing with a large number of contracts and tests.

## Test Methodology: Arrange-Act-Assert (AAA)

The Arrange-Act-Assert (AAA) methodology is a standard approach to writing tests. It consists of three main steps:
1. **Arrange**: Set up the conditions required for the function you are testing.
2. **Act**: Execute the function or action you want to test.
3. **Assert**: Verify that the outcome matches your expectations.

Using the AAA methodology ensures that your tests are structured and easy to understand.

## Writing Checks with Chisel

Chisel is a powerful tool that allows you to write and test Solidity code directly in the terminal. This can be particularly useful for quickly testing small pieces of code without the need to set up a full development environment.

## Foundry Storage Optimization

Solidity storage is essentially a large array of variables stored as persistent values. Each slot in the storage is 32 bytes long. Key points about storage:
- **Constants and immutables**: Stored in the contract's bytecode.
- **Local variables**: Stored in their own memory data structure within the function.

To inspect the storage layout of a contract in Foundry, use the `forge inspect` command. This command provides a detailed view of how variables are arranged in storage, helping you optimize and debug your contract's storage usage.

## Foundry DevOps

The `foundry-devops` package is designed to streamline contract deployment processes. It keeps track of the most recent version of a deployed contract, making it easy to install and use the package in your interaction test files.

## Using Makefile for Automation

A Makefile can significantly simplify your workflow by automating long commands. It allows you to define specific tasks and execute them with a single command. For example, you can set up a task to compile your contracts, run tests, or deploy contracts to a network.

## Programmatic Contract Deployment Verification

Verifying contract deployments on Etherscan can be done programmatically using the `--verify` flag. This flag simplifies the verification process by automatically submitting your contract's source code and metadata to Etherscan during deployment.

## ZkSync DevOps

When working with ZkSync, it's important to note that some tests will work on the vanilla version of Ethereum, while others are specific to the ZkSync chain. Additionally, some tests may not be compatible with EVM-like chains such as Ethereum. Ensure you account for these differences when writing and running tests.

## Conclusion

This guide provides an overview of key features and best practices for using Foundry in your project. By following these guidelines, you can effectively utilize Foundry to improve the efficiency and quality of your contract tests. Whether you are optimizing storage, automating tasks, or verifying deployments, these techniques will help you streamline your development process.

