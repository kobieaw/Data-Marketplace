const { assert, expect } = require('chai');
const { network, deployments, ethers, getNamedAccounts } = require('hardhat');

//Possibly make reentrant exploit test 



describe ('DataMarketplace', function () {
    let dataMarketplace, dataMarketplaceFactory, dataMarketplaceAddress;
    let deployer, alice, bob, carol;
    let dataMarketplaceContract;
    let mockV3Aggregator

    beforeEach(async function () {
        //Deploy DataMarketplace

        //const accounts = await ethers.getSigners();
        deployer = (await getNamedAccounts()).deployer;
        await deployments.fixture(["all"])
        dataMarketplace = await ethers.getContract("Marketplace", deployer);
        mockV3Aggregator = await ethers.getContract("MockV3Aggregator", deployer);
    })

    describe("constructor", async function () {
        it("sets the aggregator address correctly", async function () {
            const response = await dataMarketplace.priceFeed();
            assert.equals(response, mockV3Aggregator.address);
        })
    })
    describe("constructor2", async function () {
        it("sets the datamarketplace contract", async function () {
            const response = await dataMarketplace.dataMarketplace();
            assert.equals(response, dataMarketplace.address);
        })
    })

    describe("list data", async function () {
        it("fails if you don't list any data", async function () {
            
        })
    })

    describe("buy data", async function () {
        it("fails if you don't have sufficient funds to buy data", async function () {

        })
    })

    describe("Withdraw proceeds", async function () {
        it("fails if you don't have any proceeds to withdraw", async function () {

        })
    })

    describe("Cancel listing", async function () {
        it("fails if you don't have any listings to cancel", async function () {

        })
    })

    describe("Update Listing", async function () {
        it("fails if you don't have any listings to update", async function () {

        })
    })

    describe("Get listing", async function () {
        it("fails if you don't have any listings to get", async function () {

        })
    })

    describe("Get proceeds", async function () {
        it("fails if you don't have any proceeds to get", async function () {

        })
    })

    //tests: 
    //List data 
    //Buy data
    //Withdraw proceeds
    //Cancel listing
    //Update listing
    //Get listing
    //Get proceeds

})