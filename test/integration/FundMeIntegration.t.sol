// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol"; // This helps in using some functions for testing out our code.
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeIntegrationTest is Test {
    FundMe fundme;

    address USER = makeAddr("USER"); // making a dummy user for the testing purposes ONLY, by making using of the cheat codes.
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundme = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundfundMe = new FundFundMe();
        vm.prank(USER);
        vm.deal(USER, 1e18);
        fundfundMe.fundFundMe(address(fundme));

        WithrawFundMe withdrawfundme = new WithrawFundMe();
        withdrawfundme.withrawFundMe(address(fundme));
    }
}
