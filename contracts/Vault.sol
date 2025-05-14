// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    // Track balances per user per token
    mapping(address => uint256)  balances;
    uint256 public minUSD = 1 * 1e18;
    address constant PRICE_FEED_SEPOLIA = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    // IERC20 public immutable token = IERC20(_sepoliaAddress);  // ERC-20 token this vault accepts
    

    // 'emit' event listener
    event Deposit(address indexed user, uint256 amount);
    event Deposit(address indexed user, address indexed tokenAddress, uint256 amount);

    event Withdrawal(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, address indexed tokenAddress, uint256 amount);

    event UserBalanceCheckByAccount(address enquirerAddress, address accountHolderAddress);
    
    function deposit() public payable {
        require(msg.value > 0, "No ETH sent");
        uint256 usdValue = getConvertionRate(msg.value);
        require(usdValue >= minUSD, "Deposit must be at least $1 worth of ETH.");

        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }


    function withdraw() public payable {
        uint256 userBalance = balances[msg.sender];
        require(userBalance > 0, "Nothing to withdraw");
        
        // Set balance to 0 first (protects against re-entrancy)
        balances[msg.sender] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: userBalance}("");
        require(success, "Withdrawal failed");
        
        emit Withdrawal(msg.sender, userBalance);              // log withdrawal event
    }

    function checkBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    function checkBalanceWithAddress(address userAddress) private returns (uint256) {
        emit UserBalanceCheckByAccount(msg.sender, userAddress);
        return balances[userAddress];
    }

    // 2100000000000000 = $5.34
    function getPriceETH_USD() public view returns (uint256) {
        
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            PRICE_FEED_SEPOLIA
        );
        
        ( , int256 answer, , , ) = priceFeed.latestRoundData();
        
        require(answer > 0, "Invalid price feed");
        uint256 scaled = uint256(answer) * 1e10;
        return scaled;
    }

    function getConvertionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPriceETH_USD();
        uint256 usd = (ethPrice * ethAmount) / 1e18;
        return usd;
    }
}