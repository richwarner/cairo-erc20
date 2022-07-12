# %builtins output


## I AM NOT DONE

from starkware.cairo.common.serialize import serialize_word

func calculate_sum(n : felt) -> (sum : felt):
    if n == 0:
        return (sum=0)
    end

    let (sum) = calculate_sum(n-1)

    let sum2 = sum + n

    return (sum2)
    
end

# func main{output_ptr : felt*}():
func main{syscall_ptr : felt*, range_check_ptr}():

    let (res) = calculate_sum(n=5)

    %{ 
        print(f"summation result: {ids.res}")
    %}

    # Output the result.
    # serialize_word(res)
    return ()
end