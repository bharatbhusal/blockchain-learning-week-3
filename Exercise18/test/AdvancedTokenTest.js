const { expect } = require("chai");

// Test suite for AdvancedToken contract
describe("AdvancedToken", function () {
    let advancedToken;
    let owner;
    let addr1;

    // Deploy the contract before running tests
    it("Should deploy contract", async function () {
        advancedToken = await hre.ethers.deployContract("AdvancedToken", [], {});
        await advancedToken.waitForDeployment();
        [owner, addr1] = await hre.ethers.getSigners();
    });

    // Test constructor
    it("Should deploy with correct initial values", async function () {
        // Check if contract is deployed with correct initial values
        expect(await advancedToken.name()).to.equal("AdvancedTokenBharat");
        expect(await advancedToken.symbol()).to.equal("ABHT");
        expect(await advancedToken.decimal()).to.equal(18);
        expect(await advancedToken.totalSupply()).to.equal(500n * (10n ** 18n));
        expect(await advancedToken.maxSupply()).to.equal(5000n * (10n ** 18n));
        expect(await advancedToken.balances(owner)).to.equal(500n * (10n ** 18n));
    });

    // Test minting functions
    it("Should mint tokens by owner", async function () {
        // Initial balances and totalSupply
        const ownerBalance = await advancedToken.balances(owner);
        const userBalance = await advancedToken.balances(addr1);
        const totalSupply = await advancedToken.totalSupply();
        // Amounts to mint
        const tokensToMintToOwner = 100n * (10n ** 18n);
        const tokensToMintToUser = 50n * (10n ** 18n);

        // Mint tokens to owner and user
        await advancedToken.mintToOwner(tokensToMintToOwner);
        await advancedToken.connect(owner).mintToUser(addr1, tokensToMintToUser);

        // Check if balances and totalSupply are updated correctly
        expect(await advancedToken.totalSupply()).to.equal(totalSupply + tokensToMintToOwner + tokensToMintToUser);
        expect(await advancedToken.balances(owner)).to.equal(ownerBalance + tokensToMintToOwner);
        expect(await advancedToken.balances(addr1)).to.equal(userBalance + tokensToMintToUser);
    });

    // Non-owner should not be able to mint
    it("Non-owner should not mint tokens", async function () {
        // Initial balances
        const userBalance = await advancedToken.balances(addr1);
        const ownerBalance = await advancedToken.balances(owner);
        // Amounts to mint
        const tokensToMintToOwner = 100n * (10n ** 18n);
        const tokensToMintToUser = 50n * (10n ** 18n);

        // Non-owner attempting to mint
        await expect(advancedToken.connect(addr1).mintToOwner(tokensToMintToOwner)).to.be.revertedWith("Only owner is allowed to use this feature");
        await expect(advancedToken.connect(addr1).mintToUser(addr1, tokensToMintToUser)).to.be.revertedWith("Only owner is allowed to use this feature");

        // Check if balances remain unchanged
        expect(await advancedToken.balances(addr1)).to.equal(userBalance);
        expect(await advancedToken.balances(owner)).to.equal(ownerBalance);
    });

    // Token can't be minted beyond max Supply.
    it("Should not mint tokens beyond max supply", async function () {
        // Initial balances, maxSupply, totalSupply
        const maxSupply = await advancedToken.maxSupply();
        const totalSupply = await advancedToken.totalSupply();
        const userBalance = await advancedToken.balances(addr1);
        const ownerBalance = await advancedToken.balances(owner);
        // Amount to mint beyond maxSupply
        const tokensToMint = maxSupply - totalSupply + 1n;

        // Attempting to mint beyond maxSupply
        await expect(advancedToken.connect(owner).mintToOwner(tokensToMint)).to.be.revertedWith("Max supply exceeding");
        await expect(advancedToken.connect(owner).mintToUser(addr1, tokensToMint)).to.be.revertedWith("Max supply exceeding");

        // Check if balances remain unchanged
        expect(await advancedToken.balances(addr1)).to.equal(userBalance);
        expect(await advancedToken.balances(owner)).to.equal(ownerBalance);
    });

    // Test burning function
    it("Should burn tokens from user", async function () {
        // Initial totalSupply and user balance
        const totalSupply = await advancedToken.totalSupply();
        const userBalance = await advancedToken.balances(addr1);
        // Amount to burn
        const tokensToBurn = userBalance - 10n;

        // Burn tokens from user
        await advancedToken.connect(addr1).burn(tokensToBurn);
        // Attempting to burn more than available tokens should be reverted
        await expect(advancedToken.connect(addr1).burn(tokensToBurn + 2n)).to.be.revertedWith("Insufficient balance");

        // Check if balances and totalSupply are updated correctly
        expect(await advancedToken.balances(addr1)).to.equal(userBalance - tokensToBurn);
        expect(await advancedToken.totalSupply()).to.equal(totalSupply - tokensToBurn);
    });

    // Test locking function
    it("Should lock tokens for a specified duration", async function () {
        // Initial user balance
        const userBalance = await advancedToken.balances(addr1);
        // Tokens to lock and lock duration
        const tokendToLock = userBalance - 1n;
        const lockDuration = 36000;

        // Lock tokens for a specified duration
        await advancedToken.connect(owner).lockToken(lockDuration, tokendToLock, addr1);
        // Attempting to burn more than locked tokens should be reverted
        await expect(advancedToken.connect(addr1).burn(userBalance - tokendToLock + 1n)).to.be.revertedWith("Insufficient balance");

        // Check the locked balance after some time (3600 seconds)
        await network.provider.send("evm_increaseTime", [lockDuration]);
        await network.provider.send("evm_mine");
        await advancedToken.connect(addr1).burn(userBalance - tokendToLock + 1n);
    });

    // Test token transfer function
    it("Should transfer tokens between addresses", async function () {
        // Initial user and owner balances
        const userBalance = await advancedToken.balances(addr1);
        const ownerBalance = await advancedToken.balances(owner);
        // Tokens to transfer
        const tokensToTransfer = 10n;

        // Transfer tokens from owner to user
        await advancedToken.connect(owner).transfer(tokensToTransfer, addr1);

        // Check if balances are updated correctly
        expect(await advancedToken.balances(owner)).to.equal(ownerBalance - tokensToTransfer);
        expect(await advancedToken.balances(addr1)).to.equal(userBalance + tokensToTransfer);

        // Transfer tokens back from user to owner
        await advancedToken.connect(addr1).transfer(tokensToTransfer, owner);

        // Check if balances are updated correctly
        expect(await advancedToken.balances(addr1)).to.equal(userBalance);
        expect(await advancedToken.balances(owner)).to.equal(ownerBalance);
    });
});
