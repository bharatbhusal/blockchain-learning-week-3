# Exercise 19: Debugging Scenario
## Problem Statement: 
 Users are able to burn tokens even if tokens are locked. Your task:
1. Identify potential reasons for this bug.
2. Write a unit test in Hardhat that simulates this error.
3. Debug and fix the issue in the "AdvancedToken" contract.
4. Document the debugging steps and the solution you implemented.

## Code snippet:
```
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AdvancedToken is IERC20 {
...

    function lockTokens(address _user, uint256 _time) public onlyOwner {
        lockedUntil[_user] = block.timestamp + _time;
    }

    function burn(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough tokens");        
        balances[msg.sender] -= _amount;
        totalSupply -= _amount;

        emit Transfer(msg.sender, address(0), _amount);
    }
...
}
```

## 1. Potential Reason:
- **_burn_** function is missing a check before burning the tokens.

## 2. Unit test to simulate the bug:
### Test snippet
```
it("Should not burn locked tokens", async function () {
    await advancedToken.connect(owner).mint(addr1, 50n * (10n ** 18n));
    await advancedToken.connect(owner).lockTokens(addr1, 7n * (10n ** 18n));

    // Attempt to burn locked tokens
    await expect(advancedToken.connect(addr1).burn(45n* (10n ** 18n))).to.be.revertedWith("Tokens locked");
});
```

## 3. Debugging and Fixing bug:
**_burn_** function should have the check before executing any of the following code. 

Fixed **_burn_** function:

```
function burn(uint256 amount) external {
    require(_lockedUntil[msg.sender] <= block.timestamp, "Tokens locked");
    require(_balances[msg.sender] >= amount, "Insufficient balance to burn");

    _balances[msg.sender] -= amount;
    _totalSupply -= amount;

    emit Transfer(msg.sender, address(0), amount);
    emit TokensBurned(msg.sender, amount);
}
```

## 4. Debugging steps and solution:
### Debugging Steps:
- Identified that the users can burn their locked tokens too.
- Observe and analyse **_burn_** function.
- Simulate the error in unit test. Verifies something is wrong in **_burn_** function.
- Notice there is not check for locked tokens in **_burn_** function. 

### Solution:
- Added a check for locked tokens in **_burn_** function.
- Simulate the modified **_burn_** function in unit test. Verifies locked tokens can't be burned.



