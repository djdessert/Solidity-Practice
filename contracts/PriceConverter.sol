// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns(uint256) {
        //we'll need ABI and address of the getPrice contract
        //address 0x2C980883d2b3a38C38E087Ee8912c03eDb01674C
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x2C980883d2b3a38C38E087Ee8912c03eDb01674C);
        (,int256 price,,,) = priceFeed.latestRoundData();
        //this will be price of ETH in terms of USD
        //remember there are 8 decimal places you need to divide out
        //ms.value has 18 decmal placeds, but this price only has 8 decimal places, so we need to do some math to get them to match:
        return uint256(price * 1e10); 
        //msg.value is uint256, but price is int256, so we need to convert type as well.
    }

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x2C980883d2b3a38C38E087Ee8912c03eDb01674C);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

}