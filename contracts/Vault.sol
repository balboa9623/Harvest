// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error InsufficientBalance(uint256 balance);
error AmountNotSpecified();

contract Vault {
    using PriceConverter for uint256; // PriceConverter inherited use functionlities of uint256

    mapping(address => uint256)  balances;
    uint256 public minUSD = 1 * 1e18;
    

    // 'emit' event listener
    event DepositETH(address indexed user, uint256 amount, uint256 timestamp);
    event DepositToken(address indexed user, address indexed tokenAddress, uint256 amount, uint256 timestamp);

    event WithdrawETH(address indexed user, uint256 amount, uint256 timestamp);
    event WithdrawToken(address indexed user, address indexed tokenAddress, uint256 amount, uint256 timestamp);
    
    function deposit() public payable {
        if(msg.value <= 0) revert AmountNotSpecified();
        // require(msg.value > 0, "No ETH sent");
        uint256 usdValue = msg.value.getConvertionRate();
        require(usdValue >= minUSD, "Deposit must be at least $1 worth of ETH.");

        balances[msg.sender] += msg.value;

        emit DepositETH(msg.sender, msg.value, block.timestamp);
    }


    function withdraw() public payable {
        uint256 userBalance = checkBalance();
        // require(userBalance > 0, "Nothing to withdraw");
        if(userBalance <= 0) { revert InsufficientBalance(userBalance); }
        
        // Set balance to 0 first (protects against re-entrancy)
        balances[msg.sender] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: userBalance}("");
        require(success, "Withdrawal failed");
        
        emit WithdrawETH(msg.sender, userBalance, block.timestamp);              // log withdrawal event
    }

    // Private functions (like checkBalance) won't be visible through the Web3.py interface as they're internal to the contract
    function checkBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}