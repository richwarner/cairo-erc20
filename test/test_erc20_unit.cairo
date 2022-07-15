%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import (get_caller_address)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

const MINT_ADMIN = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95
const TEST_ACC2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b

from exercises.contracts.erc20.erc20 import balanceOf

@external
func test_proxy_contract{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    
    # %{print(f"contract_address: {ids.contract_address}") %}    

    let (admin_balance) = balanceOf(account = MINT_ADMIN)    
     
    %{print(f"MINT_ADMIN account balance: {ids.admin_balance.low}") %}    



    return ()
end


