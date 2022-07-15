%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_le, uint256_unsigned_div_rem, uint256_sub
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import unsigned_div_rem, assert_le_felt

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
    admin.write(recipient)
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

## Solution
################################################################################################    
# A mapping of permissions
@storage_var
func allowed(account : felt) -> (res : felt):
end
################################################################################################    

## Solution
################################################################################################    
@storage_var
func admin() -> (res : felt):
end

@view
func get_admin{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    admin_address : felt
):
    let (admin_address) = admin.read()
    return (admin_address)
end
################################################################################################   

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

    ## Solution even_transfer
    ################################################################################################
    let (q,r) = unsigned_div_rem(amount.low, 2)
    assert r = 0
    ################################################################################################

    ERC20_transfer(recipient, amount)    
    return (1)
end

@external
func faucet{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount:Uint256) -> (success: felt):

    ## Solution faucet
    ################################################################################################    
    uint256_le(amount, Uint256(10000,0))    
    ################################################################################################

    let (caller) = get_caller_address()
    ERC20_mint(caller, amount)
    return (1)
end

## Solution burn_haircut
################################################################################################    
@external
func burn{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount: Uint256) -> (success: felt):   

    
    alloc_locals

    ## get caller
    let (caller) = get_caller_address()
    
    ## get admin
    let (admin_address) = admin.read()    

    ## work out the haircut of 10%
    let (hair_cut, _) = uint256_unsigned_div_rem(amount, Uint256(10,0))

    ## transfer haircut to the owner    
    ERC20_transfer(admin_address, hair_cut)   

    let (acc_burn) = uint256_sub(amount, hair_cut)

    ## burn the rest     
    ERC20_burn(caller, acc_burn)   
    
    return (1)
end
################################################################################################    

## Solution exclusive_faucet
################################################################################################    
@external
func request_whitelist{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (level_granted: felt):
    
    let (caller) = get_caller_address()        
    
    allowed.write(caller, 1)

    let (level_granted) = allowed.read(caller)
    
    return (level_granted)
end
 
@external
func check_whitelist{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(account: felt) -> (allowed_v: felt):    

    ## get int for that account
    let (allowed_v) = allowed.read(account)

    return (allowed_v)
end

@external
func exclusive_faucet{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(amount: Uint256)  -> (success: felt):

    alloc_locals
        
    let (caller) = get_caller_address()
    
    ## Retrieve permission
    let (perm) = check_whitelist(caller)

    ## Abort on lack of permission
    with_attr error_message("Not allowed"):
        assert_not_zero(perm)
    end    

    ERC20_mint(caller, amount)
    return (success = 1)
end
################################################################################################    


