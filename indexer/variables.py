INFURA_API_KEY = "6f74257bc8994da7a8de6d85d833b682";
INFURA_URL = "https://sepolia.infura.io/v3/";
INFURA_RPC_URL = INFURA_URL + INFURA_API_KEY;

# CONTRACT_ADDRESS = "0x9D663b85991323d7cdB69526afc7F758B0159052";
CONTRACT_ADDRESS = "0xdeE848ad8c16fF23D519bd195fE98c3498E24361"; # contract with timestamp

# ABI = '''[
# 	{
# 		"inputs": [],
# 		"name": "AmountNotSpecified",
# 		"type": "error"
# 	},
# 	{
# 		"inputs": [],
# 		"name": "deposit",
# 		"outputs": [],
# 		"stateMutability": "payable",
# 		"type": "function"
# 	},
# 	{
# 		"inputs": [
# 			{
# 				"internalType": "uint256",
# 				"name": "balance",
# 				"type": "uint256"
# 			}
# 		],
# 		"name": "InsufficientBalance",
# 		"type": "error"
# 	},
# 	{
# 		"anonymous": false,
# 		"inputs": [
# 			{
# 				"indexed": true,
# 				"internalType": "address",
# 				"name": "user",
# 				"type": "address"
# 			},
# 			{
# 				"indexed": false,
# 				"internalType": "uint256",
# 				"name": "amount",
# 				"type": "uint256"
# 			}
# 		],
# 		"name": "DepositETH",
# 		"type": "event"
# 	},
# 	{
# 		"anonymous": false,
# 		"inputs": [
# 			{
# 				"indexed": true,
# 				"internalType": "address",
# 				"name": "user",
# 				"type": "address"
# 			},
# 			{
# 				"indexed": true,
# 				"internalType": "address",
# 				"name": "tokenAddress",
# 				"type": "address"
# 			},
# 			{
# 				"indexed": false,
# 				"internalType": "uint256",
# 				"name": "amount",
# 				"type": "uint256"
# 			}
# 		],
# 		"name": "DepositToken",
# 		"type": "event"
# 	},
# 	{
# 		"inputs": [],
# 		"name": "withdraw",
# 		"outputs": [],
# 		"stateMutability": "payable",
# 		"type": "function"
# 	},
# 	{
# 		"anonymous": false,
# 		"inputs": [
# 			{
# 				"indexed": true,
# 				"internalType": "address",
# 				"name": "user",
# 				"type": "address"
# 			},
# 			{
# 				"indexed": false,
# 				"internalType": "uint256",
# 				"name": "amount",
# 				"type": "uint256"
# 			}
# 		],
# 		"name": "WithdrawETH",
# 		"type": "event"
# 	},
# 	{
# 		"anonymous": false,
# 		"inputs": [
# 			{
# 				"indexed": true,
# 				"internalType": "address",
# 				"name": "user",
# 				"type": "address"
# 			},
# 			{
# 				"indexed": true,
# 				"internalType": "address",
# 				"name": "tokenAddress",
# 				"type": "address"
# 			},
# 			{
# 				"indexed": false,
# 				"internalType": "uint256",
# 				"name": "amount",
# 				"type": "uint256"
# 			}
# 		],
# 		"name": "WithdrawToken",
# 		"type": "event"
# 	},
# 	{
# 		"inputs": [],
# 		"name": "checkBalance",
# 		"outputs": [
# 			{
# 				"internalType": "uint256",
# 				"name": "",
# 				"type": "uint256"
# 			}
# 		],
# 		"stateMutability": "view",
# 		"type": "function"
# 	},
# 	{
# 		"inputs": [],
# 		"name": "minUSD",
# 		"outputs": [
# 			{
# 				"internalType": "uint256",
# 				"name": "",
# 				"type": "uint256"
# 			}
# 		],
# 		"stateMutability": "view",
# 		"type": "function"
# 	}
# ]
# '''


# ABI of contract with timezone
ABI = '''[
	{
		"inputs": [],
		"name": "AmountNotSpecified",
		"type": "error"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "balance",
				"type": "uint256"
			}
		],
		"name": "InsufficientBalance",
		"type": "error"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "DepositETH",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "tokenAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "DepositToken",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "WithdrawETH",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "tokenAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "WithdrawToken",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "checkBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "deposit",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "minUSD",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "withdraw",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	}
]
'''