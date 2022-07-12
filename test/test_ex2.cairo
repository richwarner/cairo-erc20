%lang starknet

from exercises.ex1 import addOne


@external
func test_addOne{syscall_ptr : felt*, range_check_ptr}():
    let (r) = addOne(4)
    assert r = 5
    return ()
end


