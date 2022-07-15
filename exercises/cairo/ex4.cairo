%lang starknet


## I AM NOT DONE

## Calculate the triangular number of any value provided
func calculate_sum(n : felt) -> (sum : felt):



    # Solution ex4
    ################################################################################################

    if n == 0:
        return (sum=0)
    end
    let (sum) = calculate_sum(n-1)
    let sum2 = sum + n
    return (sum2)
    ################################################################################################    
end

