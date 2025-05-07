// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Vault {
    mapping (address => uint256) private balances;
    uint256 public minUSD = 5 * 1e18;

    // 'emit' event listener
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Amount depositing should be greater than 1");
        balances[msg.sender] += msg.value;            // update balance
        emit Deposit(msg.sender, msg.value);          // log deposit event
    }

    function withdraw() public {
        uint256 userBalance = balances[msg.sender];
        require(userBalance > 0, "Nothing to withdraw");

        // Set balance to 0 first (protects against re-entrancy)
        balances[msg.sender] = 0;

        // Now try to send ETH
        (bool success, ) = payable(msg.sender).call{value: userBalance}("");
        require(success, "Withdrawal failed");

        emit Withdrawal(msg.sender, userBalance);              // log withdrawal event
    }

    function checkBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getPriceETH_USD() private view returns (uint256) {
        /**
        * Network: Sepolia
        * Aggregator: ETH/USD
        * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        */
        AggregatorV3Interface dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        
        (, int256 answer, , ,) = dataFeed.latestRoundData(); // Price of ETH in USD
        // msg.value and answer has different decimal places. answer has 8 decimal places (you can also call decimal() function. msg.value has 18.
        return uint256(answer) * 1e10;
    }

    function getConvertionRate(uint256 ethAmount) private view returns (uint256) {
        uint256 ethPrice = getPriceETH_USD();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }
}