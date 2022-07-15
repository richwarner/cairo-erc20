%lang starknet

from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem

## Using binary operations return: 
## - 1 when pattern of the digit is 01010101 from LSB to the latest 1, but accounts for trailing zeros
## - 0 otherwise

func pattern{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(n: felt, idx: felt, exp: felt, broken_chain: felt) -> (true : felt):

    alloc_locals              

    ## Get the digit with a fixed mask
    let (digit) = bitwise_and(1, n) 

    local new_broken_chain

    ## check pattern match
    if idx != 0:        
        ## only if end of 1s has been reached
        if broken_chain == 0:

            ## number doesn't match expectation            
            if digit != exp:                
                new_broken_chain = 1

                ## chain of 11 can be rejected right away
                if digit == 1: 
                    return (true = 0)
                end
            else:
                new_broken_chain = 0
            end            
        else: 
            if digit == 1:
                return (true = 0)
            end
            new_broken_chain = 0
        end        
    else:
        new_broken_chain = 0
    end

    ## calc next epxected bit
    if digit == 1:
        tempvar new_exp = 0        
    else: 
        tempvar new_exp = 1
    end            
    
    ## if it hasnt failed at this point and is the last shit than leave
    if idx == 250:
        return (true = 1)
    else:    
        let (q,_) = unsigned_div_rem(n,2)
        let (returned) = pattern(q, idx + 1, new_exp, new_broken_chain)
    end       
    
    return (returned)
end






