const { conflux } = require('hardhat');
const { logReceipt } = require('./conflux.js');
const { InitializeMethodData } = require('../../utils/index.js');
const {format} = require('js-conflux-sdk');

const operatorAddress= "cfxtest:aake54vmfm58n8kzkb5y3302uj1mw1z2duh2w5zaw4"

async function main() {
    const [deployer] = await conflux.getSigners();

    // deploy PoSOracle contract
    const PosOracle = await conflux.getContractFactory('PoSOracle');
    const PosOracleDeployReceipt = await PosOracle.constructor(format.hexAddress(process.env.OPERATOR_ADDRESS)).sendTransaction({
        from: deployer.address,
    }).executed();
    const PosOracleAddress = PosOracleDeployReceipt.contractCreated;
    console.log("=== pos oracle address === : ", PosOracleAddress);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});