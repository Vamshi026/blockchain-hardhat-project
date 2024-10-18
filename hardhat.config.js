require("hardhat-gas-reporter");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
require("solidity-coverage");
require("hardhat-deploy");
require("@nomiclabs/hardhat-waffle");
require("ethers");

const RPC_URL = process.env.SEPOLIA_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    sepolia: {
      url: RPC_URL,
      accounts: /*[PRIVATE_KEY]*/ [PRIVATE_KEY],
      chainId: 11155111,
      blockConfirmations: 6,
    },

    localhost: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
    },
  },
  solidity: {
    compilers: [{ version: "0.8.8" }, { version: "0.6.6" }],
  },

  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
    customChains: [],
  },

  gasReporter: {
    enabled: true,
    outputFile: "gas-report.txt",
    noColors: true,
    currency: "USD",
  },

  namedAccounts: {
    deployer: {
      default: 0,
      1: 0,
    },
  },
};
