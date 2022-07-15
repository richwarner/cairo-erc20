%lang starknet

from exercises.cairo.ex2 import addOne


@external
func test_addOne{syscall_ptr : felt*, range_check_ptr}():
    let (r) = addOne(4)
    assert r = 5    

    let (r) = addOne(88)
    assert r = 89
    return ()
end


