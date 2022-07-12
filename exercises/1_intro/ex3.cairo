#%builtins output
from starkware.cairo.common.serialize import serialize_word

# Try doing some simple arithmetic
# such as 
# adding 13 +  14
# multiplying 3 * 6
# dividing 6 by 2
# dividing 7 by 2



## func_name{syscall_ptr : felt*, range_check_ptr}
## func_name{output_ptr : felt*}

func main{syscall_ptr : felt*, range_check_ptr}():
    # serialize_word(1 + 1)


    let d = 7 / 2

    %{
        # Print the transaction values using a hint, for
        # debugging purposes.
        print(ids.d)
    %}


    let d2 = 2 * 2


    %{
        # Print the transaction values using a hint, for
        # debugging purposes.
        print(ids.d2)
    %}

    return ()
end