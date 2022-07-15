## Implement a funcion that retrns: 
## - 1 when magnitudes of inputs is equal
## - 0 otherwise
func abs_eq(x : felt, y : felt) -> (bit : felt):

    # Solution
    if x == y:        
        return (bit=1)
    end
    if x == -y:        
        return (bit=1)
    end    
    return (bit=0)    
end
