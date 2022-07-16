%lang starknet
from exercises.cairo.ex2 import addOne, addOneU256
from starkware.cairo.common.uint256 import Uint256, uint256_add

@external
func test_addOne{syscall_ptr : felt*, range_check_ptr}():
    let (r) = addOne(4)
    assert r = 5    

    let (r) = addOne(88)
    assert r = 89
    return ()
end

@external
func test_addOneU256{syscall_ptr : felt*, range_check_ptr}():
    let (r) = addOneU256(Uint256(4,0))
    assert r.low = 5    

    let (r) = addOneU256(Uint256(88,0))
    assert r.low = 89
    return ()
end

