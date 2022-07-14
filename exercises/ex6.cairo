%lang starknet

from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin

# ## Using binary operations return: 
# ## - 1 when pattern of teh digit is 01010101 (from LSB to the latest 1)
# ## - 0 otherwise

# # @external
# # func pattern{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (bit : felt):
    
# #     let y =  2

# #     %{ 
# #         print(f"passed value: {ids.y}")      
# #     %}   

# #     ## Do it recursively from the end
# #     return(y)    
# # end

# @constructor
# func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():


# end


# @view
func pattern{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    true : felt
):
    return (true = 1)
end




# Declare this file as a StarkNet contract.
# %lang starknet

# from starkware.cairo.common.cairo_builtins import HashBuiltin

# Define a storage variable.
# @storage_var
# func balance() -> (res : felt):
# end

# # Increases the balance by the given amount.
# @external
# func increase_balance{
#     syscall_ptr : felt*,
#     pedersen_ptr : HashBuiltin*,
#     range_check_ptr,
# }(amount : felt):
#     let (res) = balance.read()
#     balance.write(res + amount)
#     return ()
# end

# # Returns the current balance.
# @view
# func get_balance{
#     syscall_ptr : felt*,
#     pedersen_ptr : HashBuiltin*,
#     range_check_ptr,
# }() -> (res : felt):
#     let (res) = balance.read()
#     return (res=res)
# end