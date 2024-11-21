/* eslint-disable prettier/prettier */
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("hardhat-conflux");
require("dotenv").config();
const { task } = require("hardhat/config");
const { loadPrivateKey, loadESpacePrivateKey} = require('./utils');
const PRIVATE_KEY = loadPrivateKey();
const ESPACE_PRIVATE_KEY = loadESpacePrivateKey();

task("upgradeContract", "Upgrade a Proxy1967 Contract, assumes the implementation contract has no constructor parameters")
    .addParam("address", "The address of the proxy contract")
    .addParam("contract", "The name of the implementation contract")
    .setAction(async (taskArguments, hre, runSuper) => {
        const address = taskArguments.address;
        const name = taskArguments.contract;
        let implAddress = "";

        if (address.toLowerCase().startsWith("cfx")) {
            const [deployer] = await hre.conflux.getSigners();
            const Contract = await hre.conflux.getContractFactory(name);
            const tx = Contract.constructor().sendTransaction({
                from: deployer.address,
            });
            const receipt = await tx.executed();
            implAddress = receipt.contractCreated;

            console.log(`New ${name} impl deployed to ${implAddress}`);

            const proxy = await hre.conflux.getContractAt("Proxy1967", address);
            const tx2 = proxy.upgradeTo(implAddress).sendTransaction({
                from: deployer.address,
            });
            await tx2.executed();
        } else {
            const Contract = await hre.ethers.getContractFactory(name);
            const contract = await Contract.deploy();
            await contract.deployed();
            implAddress = contract.address;

            console.log(`New ${name} impl deployed to ${contract.address}`);

            const proxy = await hre.ethers.getContractAt("Proxy1967", address);
            const tx = await proxy.upgradeTo(contract.address);
            await tx.wait();
        }
        console.log(`Upgrade ${address} to new impl success`);
    });

task("upgradeToNewImpl", "Upgrade a Proxy1967 Contract to new implementation, assumes the implementation contract has no constructor parameters")
    .addParam("address", "The address of the proxy contract")
    .addParam("impl", "The address of new implementation")
    .setAction(async (taskArguments, hre, runSuper) => {
        const address = taskArguments.address;
        const implAddress = taskArguments.impl;

        if (address.toLowerCase().startsWith("cfx")) {
            const [deployer] = await hre.conflux.getSigners();
            const proxy = await hre.conflux.getContractAt("Proxy1967", address);
            const tx2 = proxy.upgradeTo(implAddress).sendTransaction({
                from: deployer.address,
            });
            await tx2.executed();
        } else {
            const proxy = await hre.ethers.getContractAt("Proxy1967", address);
            const tx = await proxy.upgradeTo(contract.address);
            await tx.wait();
        }
        console.log(`Upgrade ${address} to new impl success`);
    });


/**
 * @type import('hardhat/config').HardhatUserConfig
 * Go to https://hardhat.org/config/ to learn more
 */
module.exports = {
  solidity: {
      version: "0.8.20",
      settings: {
          optimizer: {
              enabled: true,
              runs: 200,
          },
      },
  },
  defaultNetwork: "espace_testnet",

  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
    cfx: {
        url: "https://main.confluxrpc.com",
        accounts: [
          PRIVATE_KEY,
        ],
        chainId: 1029,
    },
    cfx_testnet: {
      url: "https://test.confluxrpc.com",
      accounts: [
        PRIVATE_KEY,
      ],
      chainId: 1,
    },
    espace: {
      url: "https://evm.confluxrpc.com",
      accounts: [ESPACE_PRIVATE_KEY],
      chainId: 1030,
    },
    espace_testnet: {
      url: "https://evmtestnet.confluxrpc.com",
      accounts: [ESPACE_PRIVATE_KEY],
      chainId: 71,
    }
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
  },
  sourcify: {
    enabled: false,
  },
  etherscan: {
    apiKey: 'espace',
    customChains: [
      {
        network: 'espaceTestnet',
        chainId: 71,
        urls: {
          apiURL: 'https://evmapi-testnet.confluxscan.io/api/',
          browserURL: 'https://evmtestnet.confluxscan.io/',
        },
      },
    ],
  },
};
