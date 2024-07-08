// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol"; // This helps in using some functions for testing out our code.
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;

    address USER = makeAddr("USER"); // making a dummy user for the testing purposes ONLY, by making using of the cheat codes.
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundme = new FundMe();
        DeployFundMe deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinUSD() public view {
        assertEq(fundme.MIN_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log(fundme.i_owner());
        console.log(msg.sender);
        assertEq(fundme.i_owner(), msg.sender);
    }

    /*Types of Tests:
    1. Unit: Testing a specific part of the code.
    2. Integration: Testing how our code works with other parts of the code at once.
    3. Forked: Testing how our code works in a simulated read environment.
    4. Staging: Testing our code in a real envronment that is not production ready.*/
    function testgetPriceFeedVersion() public view {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); // The next line must be reverted(which means it should fail), and the revert message must be "msg.value too low"
        fundme.fund();
    }

    function testFundUpdateFundedDataStructure() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundme.getaddressToAmountFunded(USER); // Knowing whose doing what can be a little difficult with a lot contrcts and tests.
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFundertoArrayofFunders() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();

        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        // so whenever this is required in the function we can just add at the top of the function.
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundme.withdraw();
    }

    function testCanWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        // Act
        // uint256 gasStart = gasleft();
        // vm.txGasPrice(GAS_PRICE);
        vm.prank(fundme.getOwner());
        fundme.withdraw();

        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log(gasUsed);

        // Assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundMeBalance = address(fundme).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank(fundme.getFunder(i));
            hoax(address(i), STARTING_BALANCE);
            fundme.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundme).balance;
        uint256 startingOwnerBalance = fundme.getOwner().balance;

        // Act
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundme).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                address(fundme).balance
        );
        assert(
            (numberOfFunders + 1) * SEND_VALUE ==
                fundme.getOwner().balance - startingOwnerBalance
        );
    }

    // Testing cheaper withdraw function for multiple funder:
    // function testWithdrawFromMultipleFundersCheaper() public funded {
    //     // Arrange
    //     uint160 numberOfFunders = 10;
    //     uint160 startingFunderIndex = 1;

    //     for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
    //         // vm.prank(fundme.getFunder(i));
    //         hoax(address(i), SEND_VALUE);
    //         fundme.fund{value: SEND_VALUE}();
    //     }

    //     uint256 startingOwnerBalance = fundme.getOwner().balance;
    //     uint256 startingFundMeBalance = address(fundme).balance;

    //     // Act
    //     vm.startPrank(fundme.getOwner());
    //     fundme.cheaperWithdraw();
    //     vm.stopPrank();

    //     // Assert
    //     assert(address(fundme).balance == 0);
    //     assert(
    //         startingFundMeBalance + startingOwnerBalance ==
    //             address(fundme).balance
    //     );
    // }
}
