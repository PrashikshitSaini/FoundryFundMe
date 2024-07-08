// Get Funds from the users - for this the funders will call the fund function
// Withdraw Funds - Only the owner can withdraw the funds.
// Set as minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// this also acts as the interface for the code and the value that I need, in this case the price of ETH.
import {PriceConverter} from "../src/PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256; // what this does is as the all the uint256 has now access to the all the functions of the PriceConverter contract

    uint256 public constant MIN_USD = 5e18;
    // using the constant keyword for less space consumption and also less gas fee when called upon

    AggregatorV3Interface private s_pricefeed;

    address[] public s_funders; // to keep an array of all the s_funders who fund us
    mapping(address funder => uint256 amountFunded)
        public s_addressToAmountFunded;

    address public immutable i_owner;

    constructor(address priceFeed) {
        //
        i_owner = msg.sender;
        s_pricefeed = AggregatorV3Interface(priceFeed); // so now instead of the address being hardcoded, it is now dynaimcally changed
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_pricefeed) >= MIN_USD,
            "To LESS MATE"
        );

        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] =
            s_addressToAmountFunded[msg.sender] +
            msg.value;
    }

    function getVersion() public view returns (uint256) {
        // AggregatorV3Interface priceFeed = AggregatorV3Interface();
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Now this hard coded address only works for Sepolia, to make it more modular we need to make it dynamic.
        return s_pricefeed.version();
    }

    function cheaperWithdraw() public onlyOwner {
        // Rewriting the withdraw function with sotrage and gas in mind.
        uint256 fundersLength = s_funders.length; // in this we only read the length once from the storage, unlike the reading in all the loop.
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0); // resetting the array after withdrawing all the funds

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "sender not Owner MATE");
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
     * View / Pure Function Getters
     */
    function getaddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
    /**
     * Reasons for doing what we did we above:
     * 1. To make the code more readable and easy to understand.
     *
     */
}
