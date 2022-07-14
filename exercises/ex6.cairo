%lang starknet

from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

# ## Using binary operations return: 
# ## - 1 when pattern of teh digit is 01010101 (from LSB to the latest 1)
# ## - 0 otherwise

@view
func pattern{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(n: felt) -> (
    true : felt
):
    return (true = 1)
end

