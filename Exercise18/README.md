# AdvancedToken Smart Contract

## Overview

The AdvancedToken smart contract is a Solidity-based Ethereum token contract that extends the functionality of the basic ERC-20 token. It introduces additional features such as token locking and burning, along with standard functionalities like minting and transferring tokens.

## Contract Hierarchy

- **TokenBharat**: The base contract implementing basic ERC-20 functionality.
- **AdvancedToken**: Inherits from TokenBharat, enhancing it with features like token locking and burning.

## Functionalities

### TokenBharat (Base Contract)

1. **Constructor**: Initializes the token with a name, symbol, decimal places, initial supply, and maximum supply.
2. **Minting to Owner**: Only the owner can mint new tokens to their own wallet.
3. **Token Transfer**: Allows users to transfer tokens to other addresses.

### AdvancedToken (Inherited Contract)

1. **Constructor**: Sets up AdvancedToken with predefined parameters, inheriting from TokenBharat.
2. **Minting to User**: Only the owner can mint new tokens directly to a specified user's wallet.
3. **Token Burning**: Users can burn their own tokens, reducing the total token supply.
4. **Token Transfer Override**: Overrides the token transfer function to account for locked tokens; locked tokens cannot be transferred.
5. **Token Locking**: The owner can lock a specified amount of tokens in a user's wallet for a defined duration.
6. **Lock Duration Check**: Ensures that locked tokens cannot be transferred until the lock duration expires.
7. **Number of Tokens Locked**: Provides a function to query the number of tokens currently locked for a user.

## Events

The contract emits several events to provide transparency and facilitate monitoring:

- **logMint**: Signals the minting of new tokens.
- **logBurn**: Indicates the burning of tokens.
- **logTransfer**: Records token transfers between addresses.
- **logLock**: Logs the locking and unlocking of tokens, including relevant details like amount, timestamps, and user addresses.

## Testing

To ensure the correct functioning of the contract, the following unit tests are recommended:

1. Minting: Verify that tokens are minted correctly, increasing the balance accordingly.
2. Max Supply Limit: Confirm that tokens cannot be minted beyond the maximum supply.
3. Burning: Test the burning functionality, ensuring it reflects the reduced total supply.
4. Locking/Unlocking: Verify that tokens can be locked and unlocked correctly.
5. Locked Token Transfer: Confirm that locked tokens cannot be transferred until the lock duration expires.

## Error Handling

The contract includes various checks and modifiers to handle potential errors, such as insufficient balance, invalid addresses, and attempts to exceed the maximum supply.

## Deployment

To deploy the contract, use a Hardhat script, ensuring that the necessary parameters are configured correctly in the constructor.

## Conclusion

The AdvancedToken smart contract provides an extended set of features on top of a basic ERC-20 token, enabling more sophisticated token management scenarios. Users can mint, transfer, burn, and lock tokens, and events are emitted to track these operations. Careful testing and adherence to error handling ensure the robustness of the contract in various scenarios.