// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Harvest Vault
/// @notice A vault that accepts deposits/withdrawals of a default token,
///         with hidden multi-token support.
contract HarvestVault is Ownable {
    using SafeERC20 for IERC20;

    // ───────────────────────────────────────────────────────────────
    // State
    // ───────────────────────────────────────────────────────────────

    /// @notice user => token => balance
    mapping(address /* user address */=> mapping(address /* token address */ => uint256)) private balances;

    /// @notice token => is supported?
    mapping(address => bool) private isSupported;

    /// @notice list of all supported tokens
    address[] public supportedTokens;

    /// @notice the default token address (e.g., DAI) for single-token deposits
    address public immutable defaultToken;


    // ───────────────────────────────────────────────────────────────
    // Events
    // ───────────────────────────────────────────────────────────────

    /// @notice Emitted on any deposit of any token
    event Deposited(address indexed user, address indexed token, uint256 amount);

    /// @notice Emitted on any withdrawal of any token
    event Withdrawn(address indexed user, address indexed token, uint256 amount);

    /// @notice Emitted when a new token is enabled
    event TokenSupported(address indexed token);


    // ───────────────────────────────────────────────────────────────
    // Constructor
    // ───────────────────────────────────────────────────────────────

    constructor() {
        require(_defaultToken != address(0), "Zero address");
        defaultToken = _defaultToken;

        // Initialize multi-token support for the default token
        _supportToken(_defaultToken);
    }

    /// @param _defaultToken the single token users deposit for now
    constructor(address _defaultToken) {
        require(_defaultToken != address(0), "Zero address");
        defaultToken = _defaultToken;

        // Initialize multi-token support for the default token
        _supportToken(_defaultToken);
    }
    
    


    // ───────────────────────────────────────────────────────────────
    // Public Single-Token Interface
    // ───────────────────────────────────────────────────────────────

    /// @notice Deposit the default token
    /// @param amount amount of defaultToken to deposit
    function deposit(uint256 amount) external {
        _deposit(msg.sender, defaultToken, amount);
    }

    /// @notice Withdraw your full balance of the default token
    function withdrawAll() external {
        uint256 bal = balances[msg.sender][defaultToken];
        require(bal > 0, "Nothing to withdraw");

        _withdraw(msg.sender, defaultToken, bal);
    }

    /// @notice View your balance of the default token
    function balance() external view returns (uint256) {
        return balances[msg.sender][defaultToken];
    }


    // ───────────────────────────────────────────────────────────────
    // Admin-Gated Multi-Token Interface
    // ───────────────────────────────────────────────────────────────

    /// @notice Enable a new token for deposits/withdrawals
    /// @param token the ERC-20 token address to support
    function supportToken(address token) external onlyOwner {
        _supportToken(token);
    }

    /// @notice Deposit any supported token
    /// @param token the token to deposit
    /// @param amount the amount to deposit
    function depositToken(address token, uint256 amount) external {
        _deposit(msg.sender, token, amount);
    }

    /// @notice Withdraw your full balance of a supported token
    /// @param token the token to withdraw
    function withdrawToken(address token) external {
        uint256 bal = balances[msg.sender][token];
        require(bal > 0, "Nothing to withdraw");

        _withdraw(msg.sender, token, bal);
    }

    /// @notice View your balance of any supported token
    /// @param user the user address
    /// @param token the token address
    function balanceOf(address user, address token) external view returns (uint256) {
        return balances[user][token];
    }

    /// @notice List all supported tokens
    function getSupportedTokens() external view returns (address[] memory) {
        return supportedTokens;
    }


    // ───────────────────────────────────────────────────────────────
    // Internal Logic
    // ───────────────────────────────────────────────────────────────

    /// @dev Performs deposit for any token
    function _deposit(
        address user,
        address token,
        uint256 amount
    ) internal {
        require(isSupported[token], "Token not supported");
        require(amount > 0,               "Amount must be > 0");

        // Pull tokens in
        IERC20(token).safeTransferFrom(user, address(this), amount);

        // Update balance
        balances[user][token] += amount;

        emit Deposited(user, token, amount);
    }

    /// @dev Performs withdrawal for any token
    function _withdraw(
        address user,
        address token,
        uint256 amount
    ) internal {
        // Effects: set balance to zero
        balances[user][token] = 0;

        // Interaction: transfer tokens back
        (bool success, ) = _safeTransferToken(token, user, amount);
        require(success, "Withdrawal failed");

        emit Withdrawn(user, token, amount);
    }

    /// @dev Safe ERC-20 transfer wrapper using SafeERC20
    function _safeTransferToken(
        address token,
        address to,
        uint256 amount
    ) private returns (bool) {
        IERC20(token).safeTransfer(to, amount);
        return true;
    }

    /// @dev Internal: add to supported list
    function _supportToken(address token) private {
        require(token != address(0), "Zero address");
        require(!isSupported[token], "Already supported");

        isSupported[token] = true;
        supportedTokens.push(token);

        emit TokenSupported(token);
    }
}
