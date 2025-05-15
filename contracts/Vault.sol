// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error InsufficientBalance(uint256 balance);
error Unauthorized();
error AmountNotSpecified();
error InvalidPriceDataFeed();

contract Vault {

    address public /* immutable */ i_owner;
    constructor() {
        i_owner = msg.sender;
    }

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
    
    function deposit() public payable {
        if(msg.value <= 0) revert AmountNotSpecified();
        // require(msg.value > 0, "No ETH sent");
        uint256 usdValue = getConvertionRate(msg.value);
        require(usdValue >= minUSD, "Deposit must be at least $1 worth of ETH.");

        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }


    function withdraw() public payable {
        uint256 userBalance = checkBalance();
        // require(userBalance > 0, "Nothing to withdraw");
        if(userBalance <= 0) { revert InsufficientBalance(userBalance); }
        
        // Set balance to 0 first (protects against re-entrancy)
        balances[msg.sender] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: userBalance}("");
        require(success, "Withdrawal failed");
        
        emit Withdrawal(msg.sender, userBalance);              // log withdrawal event
    }

    function checkBalance() internal view returns (uint256) {
        return balances[msg.sender];
    }

    function checkBalanceWithAddress(address userAddress) private view ownerOnly returns (uint256) {
        return balances[userAddress];
    }

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

    modifier ownerOnly() {
        if (msg.sender != i_owner) revert Unauthorized();
        _;
    }
}