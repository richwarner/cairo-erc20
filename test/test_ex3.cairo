%lang starknet
from exercises.cairo.ex3 import simpleMath

@external
func test_simpleMath{syscall_ptr : felt*, range_check_ptr}():
    simpleMath()    
    return ()
end


