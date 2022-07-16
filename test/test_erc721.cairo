%lang starknet

from starkware.cairo.common.uint256 import Uint256, uint256_sub
from starkware.starknet.common.syscalls import (get_caller_address)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

const MINT_ADMIN = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95
const TEST_ACC2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b

from exercises.contracts.erc721.IERC721 import IERC721

@external
func __setup__():

    ## Deploy contract
    %{ context.contract_a_address  = deploy_contract("./exercises/contracts/erc721/erc721.cairo", [
        5338434412023108646027945078640, ## name:   CairoWorkshop
        17239,                           ## symbol: CW
        10000000000,                     ## owner: 10000000000                
        ]).contract_address 
    %}
    return ()
end


## Make it so transfer only works on multiples of 2
@external
func test_even_transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():   

    return()
end