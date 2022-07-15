%lang starknet

from starkware.cairo.common.uint256 import Uint256, uint256_sub
from starkware.starknet.common.syscalls import (get_caller_address)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

const MINT_ADMIN = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95
const TEST_ACC2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b

@contract_interface
namespace Erc20:
    func increase_balance(amount : Uint256):
    end

    func faucet(amount : Uint256) -> (success: felt):
    end

    func exclusive_faucet(amount : Uint256) -> (success: felt):
    end

    func balanceOf(account: felt) -> (res : Uint256):
    end

    func transfer(recipient: felt, amount: Uint256) -> (success: felt):
    end

    func check_whitelist(account: felt) -> (allowed_v: felt): 
    end

    func request_whitelist() -> (level_granted: felt):
    end

    func burn(amount: Uint256) -> (level_granted: felt):
    end

    func get_admin() -> (admin_address: felt):
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
func test_even_transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():

    %{print(f"\ntest_even_transfer") %}    

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

## Make a faucet that mints and transfers any value equal to or below 10,000
@external
func test_faucet{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    
    %{print(f"\ntest_faucet") %}    
    
    alloc_locals

    tempvar contract_address
    %{ ids.contract_address = context.contract_a_address %}   

    ## Call as test_acc1
    %{stop_prank_callable = start_prank(ids.TEST_ACC1, ids.contract_address)%}   

    ## Transfer even amount as mint owner to TEST_ACC1
    Erc20.faucet(contract_address=contract_address, amount = Uint256(666,0))    
    %{ stop_prank_callable() %}   

    ## Call as test_acc2
    %{stop_prank_callable = start_prank(ids.TEST_ACC2, ids.contract_address)%}   

    ## Problem
    ################################################################################################
    %{ expect_revert() %}
    ################################################################################################

    ## Transfer odd amount as mint owner to TEST_ACC1
    Erc20.transfer(contract_address=contract_address, recipient = TEST_ACC2, amount = Uint256(20000,0))    
    %{ stop_prank_callable() %}    

    return ()
end


## Create a storgae variable

## Create a getter

## Retrieve in faucet

## Assert marked as allowed


@external
func test_exclusive_faucet{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    
    alloc_locals

    tempvar contract_address
    %{ ids.contract_address = context.contract_a_address %}   

    ## Problem
    ################################################################################################

    ## Call as test_acc1
    %{stop_prank_callable = start_prank(ids.TEST_ACC1, ids.contract_address)%}   

    ## Ensure TEST_ACC1 is not on the whitelist by defualt
    let (allowed) = Erc20.check_whitelist(contract_address=contract_address, account = TEST_ACC1)        
    assert allowed = 0

    ## Apply to get on the whitelist
    let (apply) = Erc20.request_whitelist(contract_address=contract_address)        
    assert apply = 1


    ## Ensure TEST_ACC1 is now on the whitelist by defualt
    let (allowed) = Erc20.check_whitelist(contract_address=contract_address, account = TEST_ACC1)        
    assert allowed = 1

    %{ stop_prank_callable() %}    

    let (admin_balance) = Erc20.balanceOf(contract_address=contract_address, account = MINT_ADMIN)    
    %{print(f"MINT_ADMIN BOOOOO account balance: {ids.admin_balance.low}") %}    

    return ()
end




@external
func test_burn_haircut{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():

    alloc_locals

    tempvar contract_address
    %{ ids.contract_address = context.contract_a_address %}   

    let (admin_address) = Erc20.get_admin(contract_address=contract_address)

    ## Start admin balance
    let (start_admin_balance) = Erc20.balanceOf(contract_address=contract_address, account = MINT_ADMIN)    
    %{print(f"Start admin balance: {ids.start_admin_balance.low}") %}  

    ## Call as test_acc1
    %{stop_prank_callable = start_prank(ids.TEST_ACC1, ids.contract_address)%}   

    ## Get airdrop
    Erc20.faucet(contract_address=contract_address, amount = Uint256(666,0))    

    ## Call burn
    Erc20.burn(contract_address=contract_address, amount = Uint256(500,0))    

    %{ stop_prank_callable() %}   

    ## Final admin balance
    let (final_admin_balance) = Erc20.balanceOf(contract_address=contract_address, account = MINT_ADMIN)    
    %{print(f"Final adimn balance: {ids.final_admin_balance.low}") %}    

    let (admin_diff) = uint256_sub(final_admin_balance, start_admin_balance)
    
    ## Assert admin's balance increased by 50
    assert admin_diff.low = 50
    

    return ()
end