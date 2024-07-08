// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperconfig = new HelperConfig();
        address ethUsdPriceFeed = helperconfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundme = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundme;
    }
}
// At this point what we have done is that we have made the tests run for this automatically without having to go to the tests and also change the AggregatorV3interface address.
// We have made the run function such that it returns the contract type Fundme when called,  and further we made a variable of type Contract FundMe and called it fundme, so it returns the
// address of the AggregatorV3Interface address.
