const { network } = require("hardhat");

const {
  deploymentChains,
  DECIMALS,
  INITIAL_ANSWER,
} = require("../helper-hardhat-config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  //   const chainId = network.config.chainId;
  if (deploymentChains.includes(network.name)) {
    log("Local Network Detected, Deploying.........");
    await deploy("MockV3Aggregator", {
      from: deployer,
      log: true,
      args: [DECIMALS, INITIAL_ANSWER],
    });
    log("Mocks Deployed");
    log("----------------------------------");
  }
};

module.exports.tags = ["all", "mocks"];
