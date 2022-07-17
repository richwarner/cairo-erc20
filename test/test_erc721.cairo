%lang starknet

from starkware.cairo.common.uint256 import Uint256, uint256_sub
from starkware.starknet.common.syscalls import (get_caller_address)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

const MINT_ADMIN = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95
const TEST_ACC2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b

from openzeppelin.token.erc721.interfaces.IERC721 import IERC721
from exercises.contracts.erc20.IERC20 import IErc20 as Erc20

@external
func __setup__():

    ## Deploy contract erc721
    %{ context.contract_address  = deploy_contract("./exercises/contracts/erc721/erc721.cairo", [
        5338434412023108646027945078640, ## name:   CairoWorkshop
        17239,                           ## symbol: CW
        ids.MINT_ADMIN,                     ## owner: 10000000000                
        ]).contract_address 
    %}

     ## Deploy contract
    %{ context.contract_nft_address  = deploy_contract("./exercises/contracts/erc20/erc20.cairo", [
        5338434412023108646027945078640, ## name:   CairoWorkshop
        17239,                           ## symbol: CW
        10000000000,                     ## initial_supply[1]: 10000000000
        0,                               ## initial_supply[0]: 0
        ids.MINT_ADMIN
        ]).contract_address 
    %}
    return ()
end


## Implement tests for int having a limited cap and one folled by another with an increase in counter
@external
func test_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():   

    tempvar contract_address
    tempvar contract_address_erc721
    %{ ids.contract_address = context.contract_address %}    
    %{ ids.contract_address_erc721 = context.contract_nft_address %}    
    
    
    ## Call as admin    
    %{stop_prank_callable = start_prank(ids.MINT_ADMIN, ids.contract_address)%}   

    ## Transfer even amount as mint owner to TEST_ACC1
    IERC721.mint(contract_address=contract_address, to = TEST_ACC1, tokenId = Uint256(666,0))  
    %{ stop_prank_callable() %}           
    
    ## Call as admin    
    %{stop_prank_callable = start_prank(ids.TEST_ACC1, ids.contract_address)%}   

    ## Transfer NFT from TEST_ACC1 to TEST_ACC2
    IERC721.transferFrom(contract_address=contract_address, from_ = TEST_ACC1, to = TEST_ACC2, tokenId = Uint256(666,0))    
    %{ stop_prank_callable() %}       


    ## Implement a counter based where it reads the latest state

    return()
end


@external
func test_og_owner{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():   


    ## ID based field

    ## Field for tracking sales

    ## Can't burn if sold X times?


    ## Emit a sale has happened?
    ## https://github.com/l-henri/starknet-cairo-101/blob/main/contracts/ex12.cairo


    ## Mint to come from the erc20 burn?

    ## do hashing

    return()
end

## mint mechanics invokes erc20 and burns tokens

@external
func test_burn_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():   

    ## Need to call other contract and burn it for the mint by anyone to work

    ## Need to add non admin fucntion, or handle it in the existing one

    return()
end
