%lang starknet


from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin


# from exercises.ex6 import increase_balance
from exercises.ex5 import abs_eq

# @view
# @external
# func test_abs_eq{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():

#     ## test same sign, same magnitudes
#     let (r) = abs_eq(5, 5)    
#     assert 1 = r

#     let (r) = abs_eq(-2, -2)    
#     assert 1 = r    

#     ## test opposite sign, same magnitudes 
#     let (r) = abs_eq(-4, 4)        
#     assert 1 = r

#     ## test same sign, different magnitudes
#     let (r) = abs_eq(3, 40)      
#     assert 0 = r

#     ## test different sign, different magnitudes
#     let (r) = abs_eq(-3, 89)      
#     assert 0 = r

#     return ()
# end
# @external
@view
func test_calculate_sum{syscall_ptr : felt*, range_check_ptr}():
    # let (r) = calculate_sum(5)
    # assert 15 = r
    return ()
end


# # @view
# @external
# func test_pattern{syscall_ptr : felt*, range_check_ptr}():  
    
#     ## 
#     let (u) = pattern()

#     assert u = 1
    
#     return ()
# end



