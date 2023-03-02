const { network } = require("hardhat"); 
const verify = require("../utils/verify");

//Error could be at deployer parts of test.js 
//Error could also be at 

const { networkConfig, developmentChains, DECIMALS, INITIAL_ANSWER } = require("../helper-hardhat-config");

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments;
    const { deployer } = await getNamedAccounts()
    //const waitBlockConfirmations = developmentChains.includes(network.name);
    const chainId = network.config.chainId;

    //let ethUsdPriceFeedAddress
    // if(developmentChains.includes(network.name)) {
    //     const ethUsdAggregator = await deployments.get("MockV3Aggregator");
    //     ethUsdPriceFeedAddress = ethUsdAggregator.address;
    // } else {
    //     ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"];
    // }

    //When going for localhost or hardhat network we will deploy a mock

    const args = []

    // const dataMarketplace = await deploy("Marketplace", {
    //     contract: "Marketplace",
    //     from: deployer,
    //     args: args,
    //     log: true,
    //     waitConfirmations: network.config.blockConfirmations || 1,
    // });
    if(developmentChains.includes(network.name)) {
        log("network found")
        await deploy("Marketplace", {
            contract: "Marketplace",
            from: deployer,
            log: true,
            args: args
        })
    }
    if(!developmentChains.includes(network.name)) {
        log("chains found")
        await verify(dataMarketplace.address, args)

    }
    log ("Marketplace deployed!")
    log("------------------------------------");

}

module.exports.tags = ["all", "DataMarketplace"];