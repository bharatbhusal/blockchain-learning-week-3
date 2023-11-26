// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract TokenBharat {
    // Public states
    string public name;
    string public symbol;
    uint8 decimal;
    address public owner;
    uint256 public totalSupply;
    uint256 public maxSupply;

    // balance of the given address. balance getter function.
    mapping(address => uint256) public balances;

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner is allowed to use this feature");
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
        require(initialSupply <= maxSupply, "Initial supply can't be more than maxSupply");
        totalSupply = initialSupply;

        //owner of the contract owns all the supply of the token.
        balances[msg.sender] = initialSupply;
    }

  
    // function to mint the tokens in own wallet.
    function minttoOwner(uint256 amount) public onlyOwner {

        require((totalSupply + amount) <= maxSupply, "Max supply exceeding");
        //adding the balance to owner's wallet and increasing the supply.
        balances[msg.sender] += amount;
        totalSupply += amount;
    }

    //function to transfer the tokens from one wallet to another.
    function tranfer(uint256 amount, address to) public virtual {
        //the receiving wallet should be valid and sender should have enough balance.
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");
        //subtracting balance from sender and adding in receiver.
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}

contract AdvancedTokenBharat is TokenBharat{


    struct Lock{
        uint256 amount;
        uint256 unlockTimeStamp;
    }

    mapping(address => mapping(uint256 => Lock)) private lockPeriodAndAmount; //first uint lockPeriod, second uint amount.

    constructor() TokenBharat("AdvancedTokenBharat", "ABHT", 18, 500*(10**18), 5000*(10**18)){
    }

    //To mint tokens in desired user wallet by owner
    function mintToUser(address user, uint256 amount) public onlyOwner {
        require((totalSupply + amount) <= maxSupply, "Max supply exceeding");
        //adding the balance to owner's wallet and increasing the supply.
        balances[user] += amount;
        totalSupply += amount;
    }

    //To burn token from own wallet by any user
    function burn(uint256 amount) public {
        require(balances[msg.sender] - numberOfTokensLocked(msg.sender) >= amount, "Insufficient balance");
        //subtracting balance from owner's wallet and total supply
        balances[msg.sender] -= amount;
        totalSupply -= amount;
    }

    function tranfer(uint256 amount, address to) public override {
        //the receiving wallet should be valid and sender should have enough balance.
        require(balances[msg.sender] - numberOfTokensLocked(msg.sender) >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");

        //subtracting balance from sender and adding in receiver.
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function lockToken(uint256 lockDuration, uint256 amount, address user) public onlyOwner{
        require(amount > 0, "Can't lock 0 tokens");
        require(balances[user] >= amount, "Insufficient balance");
        require(lockDuration > 0, "Invalid lockDuration");
        require(user != address(0), "Invalid User address");
        uint256 unlockTimeStamp = block.timestamp + lockDuration;
        Lock memory newLock = Lock(amount, unlockTimeStamp);
        lockPeriodAndAmount[user][unlockTimeStamp] = newLock;
    }

    function numberOfTokensLocked(address user) public view returns (uint256){
        if (lockPeriodAndAmount[user][block.timestamp].unlockTimeStamp >= block.timestamp){
            return lockPeriodAndAmount[user][block.timestamp].amount;
        } else 
        return 0;
    }
}