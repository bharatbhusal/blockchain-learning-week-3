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
        expect(await advancedToken.balances(owner)).to.equal(580n * (10n ** 18n));
        expect(await advancedToken.totalSupply()).to.equal(610n * (10n ** 18n));
    });

    // Test token transfer function
    it("Should transfer tokens between addresses", async function() {
        await advancedToken.connect(owner).transfer(50n * (10n ** 18n), addr1);
        expect(await advancedToken.balances(owner)).to.equal(530n * (10n ** 18n));
        expect(await advancedToken.balances(addr1)).to.equal(80n * (10n ** 18n));
    });

    // Test locking function
    it("Should lock tokens for a specified duration", async function() {
        await advancedToken.connect(owner).lockToken(3600, 20n * (10n ** 18n), addr1);
        // await advancedToken.connect(addr1).transfer(70n * (10n ** 18n), owner);

        // Check the locked balance after some time (3600 seconds)
        await network.provider.send("evm_increaseTime", [3600]);
        await network.provider.send("evm_mine");
        await advancedToken.connect(addr1).transfer(70n * (10n ** 18n), owner);
        // expect(await advancedToken.numberOfTokensLocked(addr1)).to.equal(20n * (10n ** 18n));
    });

    // Add more tests for edge cases and additional functionalities as needed
});