// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

// TokenBharat contract containing basic token functionality
contract TokenBharat {
    // Public states
    string public name;
    string public symbol;
    uint8 public decimal;
    address public owner;
    uint256 public totalSupply;
    uint256 public maxSupply;

    // Events to log various actions
    event logMint(address indexed by, address indexed to, uint256 amount);
    event logBurn(address indexed by, address indexed from, uint256 amount);
    event logTransfer(address from, address to, uint256 amount);
    event logLock(
        address indexed by,
        address indexed from,
        uint256 amount,
        uint256 duration
    );

    // Modifier for features that only the owner can run
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner is allowed to use this feature"
        );
        _;
    }

    // Mapping to track balances of addresses
    mapping(address => uint256) public balances;

    // Constructor to initialize the token with specific parameters
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

        // TokenBharat contract's constructor caller is the owner of the contract
        owner = msg.sender;

        // Maximum supply. totalSupply can't exceed this amount.
        maxSupply = _maxSupply;

        // Total supply of the token is equal to the initially set supply.
        // Initial supply can't be more than maxSupply.
        require(
            initialSupply <= maxSupply,
            "Initial supply can't be more than maxSupply"
        );
        totalSupply = initialSupply;

        // Owner of the contract owns all the supply of the token.
        balances[msg.sender] = initialSupply;
    }

    // Function to mint the tokens in the owner's wallet
    function mintToOwner(uint256 amount) public onlyOwner {
        require((totalSupply + amount) <= maxSupply, "Max supply exceeding");
        // Adding the balance to the owner's wallet and increasing the supply.
        balances[msg.sender] += amount;
        totalSupply += amount;

        emit logMint(owner, owner, amount);
    }

    // Function to transfer the tokens from one wallet to another
    function transfer(uint256 amount, address to) public virtual {
        // The receiving wallet should be valid, and the sender should have enough balance.
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");
        // Subtracting balance from the sender and adding to the receiver.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit logTransfer(msg.sender, to, amount);
    }
}

// AdvancedToken contract inheriting from TokenBharat
contract AdvancedToken is TokenBharat {
    // Event to log each lock item
    event logLock(uint256, uint256, uint256);

    // Lock item struct
    struct Lock {
        uint256 amount;
        uint256 lockedTimeStamp;
        uint256 unlockTimeStamp;
    }

    // User address mapping to the tuple of Locks.
    // One user can have multiple lock durations for varying numbers of tokens.
    mapping(address => Lock[]) private lockPeriodAndAmount;

    // Constructor to initialize AdvancedToken with specific parameters
    constructor()
        TokenBharat(
            "AdvancedTokenBharat",
            "ABHT",
            18,
            500 * (10 ** 18),
            5000 * (10 ** 18)
        )
    {}

    // To mint tokens in a desired user wallet by the owner
    function mintToUser(address user, uint256 amount) public onlyOwner {
        require((totalSupply + amount) <= maxSupply, "Max supply exceeding");
        // Adding the balance to the owner's wallet and increasing the supply.
        balances[user] += amount;
        totalSupply += amount;

        emit logMint(owner, user, amount);
    }

    // To burn tokens from own wallet by any user
    function burn(uint256 amount) public {
        // Subtracting locked tokens while comparison.
        require(
            balances[msg.sender] - numberOfTokensLocked(msg.sender) >= amount,
            "Insufficient balance"
        );

        // Subtracting balance from owner's wallet and total supply
        balances[msg.sender] -= amount;
        totalSupply -= amount;

        emit logBurn(msg.sender, msg.sender, amount);
    }

    // Function to transfer tokens
    function transfer(uint256 amount, address to) public override {
        // Sender should have enough balance. Subtracting locked tokens while comparison.
        require(
            balances[msg.sender] - numberOfTokensLocked(msg.sender) >= amount,
            "Insufficient balance"
        );
        // The receiving wallet should be valid.
        require(to != address(0), "Invalid address");

        // Subtracting balance from sender and adding to receiver.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit logTransfer(msg.sender, to, amount);
    }

    // Function to lock tokens of any user by the owner of the contract
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

        emit logLock(owner, user, amount, lockDuration);
    }

    // Function to return the number of tokens locked by a user
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
