const { conflux } = require('hardhat');
const {format} = require('js-conflux-sdk');

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