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
    it("Should mint tokens by owner", async function() {
        const ownerBalance = await advancedToken.balances(owner);
        const userBalance = await advancedToken.balances(addr1);
        const totalSupply = await advancedToken.totalSupply();
        const tokensToMintToOwner = 100n * (10n ** 18n);
        const tokensToMintToUser = 50n * (10n ** 18n);

        await advancedToken.mintToOwner(tokensToMintToOwner);
        await advancedToken.connect(owner).mintToUser(addr1, tokensToMintToUser);

        expect(await advancedToken.totalSupply()).to.equal(totalSupply + tokensToMintToOwner + tokensToMintToUser);
        expect(await advancedToken.balances(owner)).to.equal(ownerBalance + tokensToMintToOwner);
        expect(await advancedToken.balances(addr1)).to.equal(userBalance + tokensToMintToUser);
    });

    // Non owner should not be able to mint
    it("Non owner Should not mint tokens", async function() {
        const userBalance = await advancedToken.balances(addr1);
        const ownerBalance = await advancedToken.balances(owner);
        const tokensToMintToOwner = 100n * (10n ** 18n);
        const tokensToMintToUser = 50n * (10n ** 18n);

        await expect(advancedToken.connect(addr1).mintToOwner(tokensToMintToOwner)).to.be.revertedWith("Only owner is allowed to use this feature");
        await expect(advancedToken.connect(addr1).mintToUser(addr1, tokensToMintToUser)).to.be.revertedWith("Only owner is allowed to use this feature");

        expect(await advancedToken.balances(addr1)).to.equal(userBalance);
        expect(await advancedToken.balances(owner)).to.equal(ownerBalance);

    });

    // Token can't be minted beyond max Supply.
    it("Non owner Should not mint tokens", async function() {
        const maxSupply = await advancedToken.maxSupply();
        const totalSupply = await advancedToken.totalSupply();
        const userBalance = await advancedToken.balances(addr1);
        const ownerBalance = await advancedToken.balances(owner);
        const tokensToMint = maxSupply - totalSupply + 1n;

        await expect(advancedToken.connect(owner).mintToOwner(tokensToMint)).to.be.revertedWith("Max supply exceeding");
        await expect(advancedToken.connect(owner).mintToUser(addr1, tokensToMint)).to.be.revertedWith("Max supply exceeding");

        expect(await advancedToken.balances(addr1)).to.equal(userBalance);
        expect(await advancedToken.balances(owner)).to.equal(ownerBalance);

    });

    // Test burning function
    it("Should burn tokens from user", async function() {
        const totalSupply = await advancedToken.totalSupply();
        const userBalance = await advancedToken.balances(addr1);
        const tokensToBurn = userBalance - 1n;

        await advancedToken.connect(addr1).burn(tokensToBurn);
        await expect(advancedToken.connect(addr1).burn(tokensToBurn + 2n)).to.be.revertedWith("Insufficient balance");

        expect(await advancedToken.balances(addr1)).to.equal(userBalance - tokensToBurn);
        expect(await advancedToken.totalSupply()).to.equal(totalSupply - tokensToBurn);
    });




    // // Test token transfer function
    // it("Should transfer tokens between addresses", async function() {
    //     await advancedToken.connect(owner).transfer(50n * (10n ** 18n), addr1);
    //     expect(await advancedToken.balances(owner)).to.equal(530n * (10n ** 18n));
    //     expect(await advancedToken.balances(addr1)).to.equal(80n * (10n ** 18n));
    // });

    // // Test locking function
    // it("Should lock tokens for a specified duration", async function() {
    //     await advancedToken.connect(owner).lockToken(3600, 20n * (10n ** 18n), addr1);
    //     // await advancedToken.connect(addr1).transfer(70n * (10n ** 18n), owner);

    //     // Check the locked balance after some time (3600 seconds)
    //     await network.provider.send("evm_increaseTime", [3600]);
    //     await network.provider.send("evm_mine");
    //     await advancedToken.connect(addr1).transfer(70n * (10n ** 18n), owner);
    //     // expect(await advancedToken.numberOfTokensLocked(addr1)).to.equal(20n * (10n ** 18n));
    // });

    // // Add more tests for edge cases and additional functionalities as needed
});