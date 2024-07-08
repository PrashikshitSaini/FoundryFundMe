//A way to get real like interaction with the functionality of the code.
// Fund
// Withdraw

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VAUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VAUE}();

        console.log("Funded FundMe contract with %s", SEND_VAUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        ); // how this works is that it looks inside the broadcast folder for the most recent deployment of the contract.
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithrawFundMe is Script {
    function withrawFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).withdraw();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        ); // how this works is that it looks inside the broadcast folder for the most recent deployment of the contract.
        vm.startBroadcast();
        withrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
