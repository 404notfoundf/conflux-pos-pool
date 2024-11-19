const { conflux } = require('hardhat');
const { logReceipt } = require('./conflux.js');

async function main() {
    const [deployer] = await conflux.getSigners();
    const DxCfxBridge = await conflux.getContractAt('DxCFXBridge', process.env.CORE_BRIDGE);

    // set core pos pool
    const setPosPoolReceipt = await DxCfxBridge.setPoSPool(process.env.POS_POOL).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setPosPoolReceipt, "set core space pool to DXCFXBridge");

    // set pos oracle
    const setPosOracleReceipt = await DxCfxBridge.setPoSOracle(process.env.POS_ORACLE).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setPosOracleReceipt, "set posOracle to DxCFXBridge");

    // set eSpace pool
    const setDxCFXReceipt = await DxCfxBridge.setESpacePool(process.env.ESPACE_POOL).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setDxCFXReceipt, "set eSpace pool to DxCFXBridge");

    // add fee free whitelist
    const posPool = await conflux.getContractAt('PoSPool', process.env.POS_POOL);
    const addToFeeFreeWhiteList = await posPool.addToFeeFreeWhiteList(process.env.CORE_BRIDGE).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(addToFeeFreeWhiteList, 'add free whitelist');

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});