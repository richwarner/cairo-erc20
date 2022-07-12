%lang starknet

from src.utils import sum_func
from src.ex1 import main
from src.ex2 import main as main2
from src.ex3 import main as main3
from src.ex4 import main as main4


@external
func test_sum{syscall_ptr : felt*, range_check_ptr}():
    let (r) = sum_func(4,3)
    assert r = 7
    return ()
end


@external
func test_div{syscall_ptr : felt*, range_check_ptr}():
    main3()    
    return ()
end


@external
func test_recurssion{syscall_ptr : felt*, range_check_ptr}():
    main4()    
    return ()
end