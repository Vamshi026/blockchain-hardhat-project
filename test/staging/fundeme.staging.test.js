const { assert, expect } = require("chai");
const { deployments, ethers, getNamedAccounts, network } = require("hardhat");
const { deploymentChains } = require("../../helper-hardhat-config");

deploymentChains.includes(network.name)
  ? describe.skip
  : describe("FundMe", async function () {
      let fundMe, deployer;
      const sendVal = "1000000000000000000";
      beforeEach(async function () {
        deployer = (await getNamedAccounts()).deployer;
        fundMe = await ethers.getContract("FundMe", deployer);
      });

      it("allows users to fund and withdraw", async function () {
        await fundMe.fund({ value: sendVal });
        await fundMe.withdraw();
        const endingBalance = await ethers.provider.getBalance(fundMe.address);

        assert.equal(endingBalance.toString(), "0");
      });
    });
