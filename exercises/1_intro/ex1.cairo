# %builtins output 
## if I leave ^ in it will fiob
## tests/test_utils.cairo:8:36: Unexpected implicit argument 'range_check_ptr' in an external function.
%lang starknet


## I AM NOT DONE

from starkware.cairo.common.serialize import serialize_word

func main{output_ptr : felt*}():
    serialize_word(1234)
    serialize_word(4321)
    return ()
end