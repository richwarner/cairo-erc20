%lang starknet
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin


@contract_interface
namespace PatternContract: 
    func pattern(n : felt) -> (true : felt):
    end
end

@external
func test_proxy_contract{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals

    local contract_address : felt

    # We deploy contract and put its address into a local variable. Second argument is calldata array
    %{ ids.contract_address = deploy_contract("./exercises/ex6.cairo").contract_address %}      
    
    
    let (p8) = PatternContract.pattern(contract_address=contract_address, n = 8)

    ## Solution
    %{ 
        print(f"returned value: {ids.p8}")      
    %}     
  
    return ()
end