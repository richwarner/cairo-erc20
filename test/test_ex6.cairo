# %lang starknet

# from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
# from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

# from exercises.ex6 import pattern
# # from exercises.ex5 import abs_eq

# @contract_interface
# namespace PR: 
#     func pattern() -> (true : felt):
#     end
# end

# @external
# func test_proxy_contract{syscall_ptr : felt*, range_check_ptr}():
#     alloc_locals
# end

# @external
# func test_calculate_sum{syscall_ptr : felt*, range_check_ptr}():
#     alloc_locals

#     # local contract_address : felt
#     # # We deploy contract and put its address into a local variable. Second argument is calldata array
#     # %{ ids.contract_address = deploy_contract("./exercises/ex6.cairo", [100, 0, 1]).contract_address %}

#     # let (res) = StorageContract.get_balance(contract_address=contract_address)
#     # assert res.low = 100
#     # assert res.high = 0

#     # let (id) = StorageContract.get_id(contract_address=contract_address)
#     # assert id = 1

#     # StorageContract.increase_balance(contract_address=contract_address, amount=Uint256(50, 0))

#     # let (res) = StorageContract.get_balance(contract_address=contract_address)
#     # assert res.low = 150
#     # assert res.high = 0
#     # return ()
# end




%lang starknet
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from exercises.ex6 import pattern

@contract_interface
namespace PatternContract: 
    func pattern() -> (res : felt):
    end
end

@external
func test_proxy_contract{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals

    # local contract_address : felt
    # # We deploy contract and put its address into a local variable. Second argument is calldata array
    # %{ ids.contract_address = deploy_contract("./exercises/erc20.cairo", [100, 0, 1]).contract_address %}

    # let (res) = StorageContract.get_balance(contract_address=contract_address)
    # assert res.low = 100
    # assert res.high = 0

    # let (id) = StorageContract.get_id(contract_address=contract_address)
    # assert id = 1

    # StorageContract.increase_balance(contract_address=contract_address, amount=Uint256(50, 0))

    # let (res) = StorageContract.get_balance(contract_address=contract_address)
    # assert res.low = 150
    # assert res.high = 0
    return ()
end