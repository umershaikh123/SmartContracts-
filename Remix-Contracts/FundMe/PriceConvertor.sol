// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
   function getEthRate() internal view returns (uint256) {
      AggregatorV3Interface priceFeed = AggregatorV3Interface(
         0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
      );
      (, int256 price, , , ) = priceFeed.latestRoundData();
      return uint256(price * 1e10);
   }

   function getConversionRate(uint256 ethAmount)
      internal
      view
      returns (uint256)
   {
      uint256 ethPrice = getEthRate();
      uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
      return ethAmountInUsd;
   }
}
