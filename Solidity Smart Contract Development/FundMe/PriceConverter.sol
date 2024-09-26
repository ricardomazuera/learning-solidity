// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // getPrices is to obtain the price coin vs ethereum
    function getPrice() internal view returns (uint256) {
        /*
        We need:
        - Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306 Sepolia
        - Address: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF zkSync Sepolia
        - ABI
        */
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (
            /* uint80 roundID */,
            int256 price,
            /*uint256 startedAt*/,
            /*uint256 timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        /*
            In this function, the USD/ETH value is returned with 8 zero
            for that, we need to multiply the resulting value with 1e10, because we need to match the msg.value (it is returned with 1e18 zeros) with the price.
            match the msg.value (it is returned with 1e18 zeros) with the price.
        */
        return uint256(price*1e10);
    } 

    function getCoversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        /*
            We need divide the result between 1e18, because
            when you plus 1e18 * 1e18, the result is 1e36 and we 
            need the result just with 1e18.
        */
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}