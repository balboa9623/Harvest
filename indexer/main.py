import json;
from web3 import Web3;
from variables import *;
from datetime import datetime, timezone;

# Establish a connection to the provider using HTTP protocol.
# HTTP slower compared to WebSocket because HTTP reconnects on every request and WebSocker maintains a persistant connection
# May upgrade to WebSocket later. Keeping HTTP to testing purpose.
web3 = Web3(Web3.HTTPProvider(INFURA_RPC_URL));#, request_kwargs={'timeout': 60});

# connection_wait(3);
   
assert web3.is_connected(), "Connection could not be established";

# balance = web3.eth.get_balance(CONTRACT_ADDRESS)
# if you want to convert token currency (ERC-20) to 'ether', u can use web3.from_wei(balance, 'ether'{desired token})
# balance_in_ether = web3.from_wei(balance, "ether")

# ABI of your deployed contract
vault_abi = json.loads(ABI)
# Python representation of Sepolia token (implements ERC-20 token)
vault = web3.eth.contract(address=CONTRACT_ADDRESS, abi=vault_abi)
# List of useful functions:
# 1. contract.functions => lists all functions to you
# 2. contract.functions.totalSupply() => total supply of tokens available
# 3. web3.functions.name().call() => gets your token name

# start block value needs to be updated when deploying the actual contract. Now testing with test contract
# start_block = 0
# check the latest block number
# end_block = web3.eth.block_number

# create_filter is a real-time listener that waits for new logs. When a new deposit is triggered this filter catches it instantly. Caveat: Filters aren't persisted — if your script dies, you may miss events.
# deposit_event_filter = contract.events.Deposit.create_filter(from_block='latest')
# get_logs, etches events between two blocks. Suitable for dev purpose
# deposit_logs  = vault.events.DepositETH.get_logs(from_block=start_block, to_block=end_block)
# withdraw_logs = vault.events.WithdrawETH.get_logs(from_block=start_block, to_block=end_block)

def unix_to_utc(timestamp):
    # Convert to UTC datetime object
    utc_datetime = datetime.fromtimestamp(timestamp, tz=timezone.utc)
    # Format as string in desired format
    formatted_utc = utc_datetime.strftime("%m/%d/%Y %H:%M:%S")
    return formatted_utc

deposit_filter = vault.events.DepositETH.create_filter(from_block=8443076, to_block='latest')
withdraw_filter = vault.events.WithdrawETH.create_filter(from_block=8443076, to_block='latest')

# for deposit in deposit_filter.get_all_entries():
#     print(f"User: {deposit.args.user} made a deposit of amount: {deposit.args.amount} wei ({web3.from_wei(deposit.args.amount, 'ether')} ETH/ether) @ {unix_to_utc(deposit.args.timestamp)}. blockNumber = {deposit.blockNumber}");

# for withdrawal in withdraw_filter.get_all_entries():
#     print(f"User: {withdrawal.args.user} made a withdrawal of amount: {withdrawal.args.amount} wei ({web3.from_wei(withdrawal.args.amount, 'ether')} ETH/ether) @ {unix_to_utc(withdrawal.args.timestamp)}. blockNumber = {withdrawal.blockNumber}");

