import json;
from web3 import Web3;
from variables import *;
from datetime import datetime, timezone;

# Establish a connection to the provider using HTTP protocol.
# HTTP slower compared to WebSocket because HTTP reconnects on every request and WebSocker maintains a persistant connection
# May upgrade to WebSocket later. Keeping HTTP to testing purpose.
web3 = Web3(Web3.HTTPProvider(INFURA_RPC_URL));#, request_kwargs={'timeout': 60});
   
assert web3.is_connected(), "Connection could not be established";

# ABI of your deployed contract
vault_abi = json.loads(ABI)
vault = web3.eth.contract(address=CONTRACT_ADDRESS, abi=vault_abi)

def unix_to_utc(timestamp):
    utc_datetime = datetime.fromtimestamp(timestamp, tz=timezone.utc)
    formatted_utc = utc_datetime.strftime("%m/%d/%Y %H:%M:%S")
    return formatted_utc

deposit_filter = vault.events.DepositETH.create_filter(from_block=8443076, to_block='latest')
withdraw_filter = vault.events.WithdrawETH.create_filter(from_block=8443076, to_block='latest')

print(deposit_filter.get_all_entries())
print(withdraw_filter.get_all_entries())
