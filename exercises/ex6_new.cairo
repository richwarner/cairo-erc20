%lang starknet

from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

# ## Using binary operations return: 
# ## - 1 when pattern of teh digit is 01010101 (from LSB to the latest 1)
# ## - 0 otherwise


## finds most significant 1
func ms_1{bitwise_ptr: BitwiseBuiltin*}(n: felt) -> (true : felt):




end

## it needs to receive counyter for how many jumps to do, also what is the
## counter, expected bit
func pattern{bitwise_ptr: BitwiseBuiltin*}(n: felt, idx: felt, exp: felt) -> (true : felt):

    ## two different runs starting 

    ## 
    # if idx == 0: 

    # end

    # bitwise_ptr.x = n

    %{ 
        print(f"returned value: {ids.bitwise_ptr[0].x}")      
    %}   



    # bitwise_ptr[0].x = values[0]


    ## find next bit



    ## and to see what happens

    let (result) = bitwise_and(12, 10)  # Binary (1100, 1010).
    return (true = 1)
end


func masking{bitwise_ptr: BitwiseBuiltin*}(masked: felt):

    return ()
end