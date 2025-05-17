// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


error InvalidPriceDataFeed();

library PriceConverter {

    address constant PRICE_FEED_SEPOLIA = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    // 2100000000000000 = $5.34
    function getPriceETH_USD() public view returns (uint256) {
        
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            PRICE_FEED_SEPOLIA
        );
        
        ( , int256 price, , , ) = priceFeed.latestRoundData();
        
        // require(price > 0, "Invalid price feed");
        if(price <= 0) {revert InvalidPriceDataFeed();}
        uint256 scaled = uint256(price) * 1e10;
        return scaled;
    }

    function getConvertionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPriceETH_USD();
        uint256 usd = (ethPrice * ethAmount) / 1e18;
        return usd;
    }
}