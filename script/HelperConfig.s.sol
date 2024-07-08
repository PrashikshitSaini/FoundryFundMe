// 1. Deploy Mocks when we are on a local anvil chain.
// 2. Keep track of contract addresses across different chains.
// for eg. Sepolia ETH/USD has a different address from mainnet ETH/USD.
// If we set this up right we can work with both local chains and also across different chains.

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockv3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on a local anvil chain, we deploy mocks.
    // Otherwise, grab the existing address from the live network.

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8; // TIP for a more readbale code, making it more easier to access and understand later.

    NetworkConfig public activeNetworkConfig;
    struct NetworkConfig {
        address priceFeed; //Eth/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // This will return everything from the sepolia feed, but we actually just need the price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        // 1. Deploy the mocks.
        // 2. Return the address of the mocks.

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_ANSWER
        );
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockpricefeed)
        });
        return anvilConfig;
    }
}
