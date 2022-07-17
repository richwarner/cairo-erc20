%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_le, uint256_unsigned_div_rem, uint256_sub
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import unsigned_div_rem, assert_le_felt
from starkware.cairo.common.dict import dict_new, dict_read
from starkware.cairo.common.dict_access import DictAccess

from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
    assert_nn,
    assert_le,
    assert_lt,    
    assert_in_range,
)

from exercises.contracts.erc20.ERC20_base import (
    ERC20_name,
    ERC20_symbol,
    ERC20_totalSupply,
    ERC20_decimals,
    ERC20_balanceOf,
    ERC20_allowance,
    ERC20_mint,
    ERC20_initializer,       
    ERC20_transfer,    
    ERC20_burn
)

@storage_var
func admin() -> (res : felt):
end

@storage_var
func whitelist(account: felt) -> (whitelisted: felt):
end

@constructor
func constructor{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        name: felt,
        symbol: felt,
        initial_supply: Uint256,
        recipient: felt
    ):
    ERC20_initializer(name, symbol, initial_supply, recipient)    
    let (admin_address) = get_caller_address()
    admin.write(admin_address)
    return ()
end

@view
func name{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (name: felt):
    let (name) = ERC20_name()
    return (name)
end

@view
func symbol{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (symbol: felt):
    let (symbol) = ERC20_symbol()
    return (symbol)
end

@view
func totalSupply{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (totalSupply: Uint256):
    let (totalSupply: Uint256) = ERC20_totalSupply()
    return (totalSupply)
end

@view
func decimals{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (decimals: felt):
    let (decimals) = ERC20_decimals()
    return (decimals)
end

@view
func balanceOf{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(account: felt) -> (balance: Uint256):
    let (balance: Uint256) = ERC20_balanceOf(account)
    return (balance)
end

@view
func allowance{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(owner: felt, spender: felt) -> (remaining: Uint256):
    let (remaining: Uint256) = ERC20_allowance(owner, spender)
    return (remaining)
end


# Externals
################################################################################################

@external
func transfer{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(recipient: felt, amount: Uint256) -> (success: felt):
    # added
    let (quotient, remainder) = uint256_unsigned_div_rem(a = amount, div = Uint256(2,0))
    assert remainder.low = 0
    # end added
    ERC20_transfer(recipient, amount)    
    return (1)
end

@external
func faucet{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount:Uint256) -> (success: felt):
    # added
    assert_lt(amount.low, 10000)
    # end added
    let (caller) = get_caller_address()
    ERC20_mint(caller, amount)
    return (1)
end

@external 
func get_admin{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (res: felt):
    let (res) = admin.read()
    return (res=res)
end

@external
func burn{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount: Uint256) -> (success: felt):   
    # added
    alloc_locals
    let (admin) = get_admin()
    %{ print(admin) %}    
    let (keep, _) = uint256_unsigned_div_rem(a = amount, div = Uint256(10, 0))
    let (burn) = uint256_sub(a = amount, b = keep)
    ERC20_transfer(admin, keep)
    ERC20_burn(admin, burn)
    # end added
    return (0)
end

@external
func exclusive_faucet{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount : Uint256) -> (success: felt):
    alloc_locals
    let (local caller) = get_caller_address() 
    let (whitelisted) = check_whitelist(caller)
    if whitelisted == 1:
        transfer(caller, amount)
    end
    return (1)
end

@external
func check_whitelist{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(account: felt) -> (allowed_v: felt): 
    alloc_locals
    let (caller) = get_caller_address()
    let (whitelisted) = whitelist.read(caller)
    return(whitelisted)
end

@external
func request_whitelist{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (level_granted: felt):
    alloc_locals
    let (caller) = get_caller_address()
    whitelist.write(caller, 1)
    return (1)
end    
