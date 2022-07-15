%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import (get_caller_address)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

const MINT_ADMIN = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95
const TEST_ACC2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b


@contract_interface
namespace Erc20:
    func increase_balance(amount : Uint256):
    end

    func balanceOf(account: felt) -> (res : Uint256):
    end

    func transfer(recipient: felt, amount: Uint256) -> (success: felt):
    end
end



@external
func __setup__():

    ## Deploy contract
    %{ context.contract_a_address  = deploy_contract("./exercises/contracts/erc20/erc20.cairo", [
        5338434412023108646027945078640, ## name:   CairoWorkshop
        17239,                           ## symbol: CW
        10000000000,                     ## initial_supply[1]: 10000000000
        0,                               ## initial_supply[0]: 0
        ids.MINT_ADMIN
        ]).contract_address 
    %}
    return ()
end

## Make it so transfer only works on multiples of 2
@external
func test_proxy_contract{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    tempvar contract_address
    %{ ids.contract_address = context.contract_a_address %}    
    
    ## Call as admin    
    %{stop_prank_callable = start_prank(ids.MINT_ADMIN, ids.contract_address)%}   

    ## Transfer even amount as mint owner to TEST_ACC1
    Erc20.transfer(contract_address=contract_address, recipient = TEST_ACC1, amount = Uint256(666,0))    

    ## Problem
    ################################################################################################
    %{ expect_revert() %}
    ################################################################################################

    ## Transfer odd amount as mint owner to TEST_ACC1
    Erc20.transfer(contract_address=contract_address, recipient = TEST_ACC2, amount = Uint256(111,0))    

    %{ stop_prank_callable() %}    

    return ()
end


# @external
# func test_proxy_contract2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
#     alloc_locals

#     local contract_address : felt
    
#     ## Hardcoded don't change
#     %{ ids.contract_address = deploy_contract("./exercises/contracts/erc20/erc20.cairo", [
#         5338434412023108646027945078640, ## name:   CairoWorkshop
#         17239,                           ## symbol: CW
#         10000000000,                               ## initial_supply[1]: 10000000000
#         0,                               ## initial_supply[0]: 0
#         ids.MINT_ADMIN
#         ]).contract_address 
#     %}

#     ## Call as admin    
#     %{stop_prank_callable = start_prank(ids.MINT_ADMIN, ids.contract_address)%}   

#     ## Transfer even amount as mint owner to TEST_ACC1
#     Erc20.transfer(contract_address=contract_address, recipient = TEST_ACC1, amount = Uint256(666,0))    

#     ## Problem
#     ################################################################################################
#     %{ expect_revert() %}
#     ################################################################################################

#     ## Transfer odd amount as mint owner to TEST_ACC1
#     Erc20.transfer(contract_address=contract_address, recipient = TEST_ACC2, amount = Uint256(111,0))    

#     %{ stop_prank_callable() %}
    

#     return ()
# end

## At the moment only minter can transfer make it so anyone can do it

# @external
# func test_transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    
#     alloc_locals
    
#     ## retrieve contract address
#     let (contract_address) = contract_address_storage.read()

#     %{print(f"contract_address: {ids.contract_address}") %}    

#     # ## Get balance of the MINT_ADMIN
#     let (admin_balance) = Erc20.balanceOf(contract_address=contract_address, account = MINT_ADMIN)    

#     # %{print(f"MINT_ADMIN account balance: {ids.admin_balance.low}") %}    

#     # ## Call as admin
#     # %{stop_prank_callable = start_prank(ids.MINT_ADMIN, ids.contract_address)%}   

#     # ## transfer as mint owner
#     # Erc20.transfer(contract_address=contract_address, recipient = TEST_ACC1, amount = Uint256(666,0))    

#     # %{ stop_prank_callable() %}

#     # let (admin_balance) = Erc20.balanceOf(contract_address=contract_address, account = MINT_ADMIN)    
#     # %{print(f"MINT_ADMIN account balance: {ids.admin_balance.low}") %}    

#     # let (balance_test_acc1) = Erc20.balanceOf(contract_address=contract_address, account = TEST_ACC1)    
#     # %{print(f"TEST_ACC1 account balance: {ids.balance_test_acc1.low}") %}       

#     return ()
# end