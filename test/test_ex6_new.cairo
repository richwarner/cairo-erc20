%lang starknet
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin


from exercises.ex6_new import pattern

@external
func test_proxy_contract{syscall_ptr : felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}():
    
    alloc_locals      
        
    let (p8) = pattern(n = 99)

    ## Solution
    %{ 
        print(f"returned value: {ids.p8}")      
    %}     
  
    return ()
end