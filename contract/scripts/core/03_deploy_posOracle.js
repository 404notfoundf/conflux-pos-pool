const { conflux } = require('hardhat');
const { logReceipt } = require('./conflux.js');
const { InitializeMethodData } = require('../../utils/index.js');

async function main() {
    const [deployer] = await conflux.getSigners();

    // deploy PoSOracle contract
    const PosOracle = await conflux.getContractFactory('PoSOracle');
    const PosOracleDeployReceipt = await PosOracle.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const PosOracleAddr = PosOracleDeployReceipt.contractCreated;
    console.log("=== pos oracle address === : ", PosOracleAddr);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});