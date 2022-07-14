%lang starknet

from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

# ## Using binary operations return: 
# ## - 1 when pattern of teh digit is 01010101 (from LSB to the latest 1)
# ## - 0 otherwise

func pattern{bitwise_ptr: BitwiseBuiltin*}(n: felt) -> (
# func pattern(n: felt) -> (
    true : felt
):

    # let n1 = [n + 1]

    # let (result) = bitwise_and(12, 10)  # Binary (1100, 1010).
    # %{ 
    #     print(f"result value: {ids.result}")      
    # %}     

    ## find latest 1


    ## create mask of same length


    ## and to see what happens

    let (result) = bitwise_and(12, 10)  # Binary (1100, 1010).
    return (true = 1)
end
