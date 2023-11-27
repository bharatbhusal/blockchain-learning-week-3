const {
    expect
} = require("chai");

describe("AdvancedToken", function() {
    let advancedToken;
    let owner;
    let addr1;



    it("Should deploy contract", async function() {
        advancedToken = await hre.ethers.deployContract("AdvancedToken", [], {});
        await advancedToken.waitForDeployment();
        [owner, addr1] = await hre.ethers.getSigners();

    })

    // Test constructor
    it("Should deploy with correct initial values", async function() {
        expect(await advancedToken.name()).to.equal("AdvancedTokenBharat");
        expect(await advancedToken.symbol()).to.equal("ABHT");
        expect(await advancedToken.decimal()).to.equal(18);
        expect(await advancedToken.totalSupply()).to.equal(500n * (10n ** 18n));
        expect(await advancedToken.maxSupply()).to.equal(5000n * (10n ** 18n));
        expect(await advancedToken.balances(owner)).to.equal(500n * (10n ** 18n));
    });

    // Test minting functions
    it("Should mint tokens to owner", async function() {
        await advancedToken.mintToOwner(100n * (10n ** 18n));
        expect(await advancedToken.totalSupply()).to.equal(600n * (10n ** 18n));
        expect(await advancedToken.balances(owner)).to.equal(600n * (10n ** 18n));
    });

    it("Should mint tokens to user by owner", async function() {
        await advancedToken.connect(owner).mintToUser(addr1, 50n * (10n ** 18n));
        expect(await advancedToken.balances(addr1)).to.equal(50n * (10n ** 18n));
    });

    // Test burning function
    it("Should burn tokens from user by user", async function() {
        await advancedToken.connect(addr1).burn(20n * (10n ** 18n));
        await advancedToken.connect(owner).burn(20n * (10n ** 18n));
        expect(await advancedToken.balances(addr1)).to.equal(30n * (10n ** 18n));
        expect(await advancedToken.totalSupply()).to.equal(610n * (10n ** 18n));
    });

    // // Test token transfer function
    // it("Should transfer tokens between addresses", async function() {
    //     // Mint some tokens first
    //     await advancedToken.mintToOwner(100);

    //     await advancedToken.connect(owner).transfer(user.address, 50);
    //     expect(await advancedToken.balances(owner.address)).to.equal(50);
    //     expect(await advancedToken.balances(user.address)).to.equal(50);
    // });

    // // Test locking function
    // it("Should lock tokens for a specified duration", async function() {
    //     // Mint some tokens first
    //     await advancedToken.mintToOwner(100);

    //     await advancedToken.connect(owner).lockToken(3600, 20, user.address);

    //     // Check the locked balance after some time (3600 seconds)
    //     await network.provider.send("evm_increaseTime", [3600]);
    //     await network.provider.send("evm_mine");

    //     expect(await advancedToken.numberOfTokensLocked(user.address)).to.equal(20);
    // });

    // Add more tests for edge cases and additional functionalities as needed
});