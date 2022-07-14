%lang starknet

from exercises.ex4 import calculate_sum

@external
func test_calculate_sum{syscall_ptr : felt*, range_check_ptr}():
    let (r) = calculate_sum(5)
    assert 15 = r
    return ()
end
