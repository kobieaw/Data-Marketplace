require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require("hardhat-deploy");
require("solidity-coverage");
require("hardhat-contract-sizer");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL;
const POLYGON_TESTNET_RPC_URL = process.env.POLYGON_TESTNET_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const MNEMONIC = process.env.MNEMONIC;

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY;
const REPORT_GAS = process.env.REPORT_GAS;

module.exports = {
  solidity: "0.8.17",
  solidity: {
    compilers: [
      { version: "0.8.8" }, 
      { version: "0.6.6" }, 
    ],
  },
  defaultNetwork: "hardhat",
  networks: {
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 5,
      blockConfirmations: 1,
    },
  }, 
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY, 
  },
  gasReporter: {
    enabled: true, 
    currency: "USD",
    outputFile: "gas-report.txt",
    noColors: true,
  },
  namedAccounts: {
    deployer: {
      default: 0,
    }, 
    user: {
      default: 1
    },
  }, 
  mocha: {
    timeout: 500000,
  }
};
