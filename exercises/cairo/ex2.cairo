from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import Uint256, uint256_add

# Modify both functions so that they
# incremented value by one and return it
func addOne(y : felt) -> (bit : felt):   
   return (y) 
end

func addOneU256{range_check_ptr}(y : Uint256) -> (bit : Uint256):   
   return (y) 
end
