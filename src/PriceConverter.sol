// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// In foundry we need to download this repo locally on our device, and using forge install __________ --no-commit and then the path for the same

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // Address - kind of address that acts like part of API in web2 = 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI - The code that acts as the interface between our code and the chainlink feed which is imported up top. ✅
        // price typer of variable that is of the type Aggregator Interface
        (, int256 price, , , ) = priceFeed.latestRoundData(); // this price gives out the price of eth in USD, with no decimals.
        return uint256(price * 1e10); // this is done because the msg.value will have 18 zeros and the price only has 8 so to bring them on a same level, we do this.
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountinUSD = (ethAmount * ethPrice) / 1e18;
        return ethAmountinUSD;
    }
}
