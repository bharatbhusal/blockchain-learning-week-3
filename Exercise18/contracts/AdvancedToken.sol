//Exercise 18: Hardhat Deployment and Testing
//   -Problem Statement: Deploy the "AdvancedToken" contract onto the Hardhat Network and write unit tests to ensure functionalities. Tests should also ensure error scenarios are handled correctly. For instance, non-owners shouldn't be able to mint tokens.
//   - eployment: Write a Hardhat script to deploy your contract.
//   - Unit Testing:** Write tests to ensure:
//    1. Tokens are minted correctly and reflected in the balance.
//    2. Tokens cannot be minted beyond the maximum supply.
//    3. Users can burn their tokens, reflecting the reduced total supply.
//    4. Tokens can be locked and unlocked correctly.
//    5. Locked tokens cannot be transferred.=================================================================================================================================

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract TokenBharat {
    // Public states
    string public name;
    string public symbol;
    uint8 public decimal;
    address public owner;
    uint256 public totalSupply;
    uint256 public maxSupply;

    // balance of the given address. balance getter function.
    mapping(address => uint256) public balances;

    //modifier for features that only owner can run.
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner is allowed to use this feature"
        );
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimal,
        uint256 initialSupply,
        uint256 _maxSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimal = _decimal;

        //TokenBharat contract's constructor caller is the owner of the contract.
        owner = msg.sender;

        //Maximum supply. totalSupply can't exceed this amount.
        maxSupply = _maxSupply;

        // total supply of the token is equal to the initially set supply.
        //initial supply can't be more than maxsupply.
        require(
            initialSupply <= maxSupply,
            "Initial supply can't be more than maxSupply"
        );
        totalSupply = initialSupply;

        //owner of the contract owns all the supply of the token.
        balances[msg.sender] = initialSupply;
    }

    // function to mint the tokens in own wallet.
    function mintToOwner(uint256 amount) public onlyOwner {
        require((totalSupply + amount) <= maxSupply, "Max supply exceeding");
        //adding the balance to owner's wallet and increasing the supply.
        balances[msg.sender] += amount;
        totalSupply += amount;
    }

    //function to transfer the tokens from one wallet to another.
    function transfer(uint256 amount, address to) public virtual {
        //the receiving wallet should be valid and sender should have enough balance.
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");
        //subtracting balance from sender and adding in receiver.
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}

contract AdvancedToken is TokenBharat {
    //event to log each lock item.
    event logLock(uint256, uint256, uint256);

    //Lock iteam struct
    struct Lock {
        uint256 amount;
        uint256 lockedTimeStamp;
        uint256 unlockTimeStamp;
    }

    //user address mapping to the tuple of Locks. one user can have multiple lock duration for varying number of tokens.
    mapping(address => Lock[]) private lockPeriodAndAmount;

    constructor()
        TokenBharat(
            "AdvancedTokenBharat",
            "ABHT",
            18,
            500 * (10 ** 18),
            5000 * (10 ** 18)
        )
    {}

    //To mint tokens in desired user wallet by owner
    function mintToUser(address user, uint256 amount) public onlyOwner {
        require((totalSupply + amount) <= maxSupply, "Max supply exceeding");
        //adding the balance to owner's wallet and increasing the supply.
        balances[user] += amount;
        totalSupply += amount;
    }

    //To burn token from own wallet by any user
    function burn(uint256 amount) public {
        //subtracting locked tokens while comparision.
        require(
            balances[msg.sender] - numberOfTokensLocked(msg.sender) >= amount,
            "Insufficient balance"
        );

        //subtracting balance from owner's wallet and total supply
        balances[msg.sender] -= amount;
        totalSupply -= amount;
    }

    function transfer(uint256 amount, address to) public override {
        //Sender should have enough balance. subtracting locked tokens while comparision.
        require(
            balances[msg.sender] - numberOfTokensLocked(msg.sender) >= amount,
            "Insufficient balance"
        );
        // the receiving wallet should be valid
        require(to != address(0), "Invalid address");

        //subtracting balance from sender and adding in receiver.
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    //Funtion to lock tokens of any user by owner of contract.
    function lockToken(
        uint256 lockDuration,
        uint256 amount,
        address user
    ) public onlyOwner {
        require(amount > 0, "Can't lock 0 tokens");
        require(balances[user] >= amount, "Insufficient balance");
        require(lockDuration > 0, "Invalid lockDuration");
        require(user != address(0), "Invalid User address");

        uint256 unlockTimeStamp = block.timestamp + lockDuration;
        Lock memory newLock = Lock(amount, block.timestamp, unlockTimeStamp);
        emit logLock(
            newLock.amount,
            newLock.lockedTimeStamp,
            newLock.unlockTimeStamp
        );

        lockPeriodAndAmount[user].push(newLock);
    }

    //function to return number of tokens locked of a user.
    function numberOfTokensLocked(address user) private view returns (uint256) {
        Lock[] memory userLock = lockPeriodAndAmount[user];
        for (uint8 i = 0; i < userLock.length; i++) {
            if (userLock[i].unlockTimeStamp >= block.timestamp) {
                return (userLock[i].amount);
            }
        }
        return 0;
    }
}
