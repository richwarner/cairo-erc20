%lang starknet
from exercises.cairo.ex1 import logValue

@external
func test_logValue{syscall_ptr : felt*, range_check_ptr}():

    ## value to pass
    let p = 42

    %{print(f"passing value: {ids.p}")%}    

    logValue(p)
    
    return ()
end


