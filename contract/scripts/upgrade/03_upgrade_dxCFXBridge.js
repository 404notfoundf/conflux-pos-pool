const { conflux } = require('hardhat');
const { logReceipt } = require('../core/conflux.js');
async function main() {
    const [deployer] = await conflux.getSigners();

    // deploy DxCFXBridge Contract
    const DxCFXBridge = await conflux.getContractFactory('DxCFXBridge');
    const DxCFXBridgeDeployReceipt = await DxCFXBridge.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const DxCFXBridgeImplAddr = DxCFXBridgeDeployReceipt.contractCreated;
    console.log("=== dx cfx bridge impl address === : ", DxCFXBridgeImplAddr);

    // upgrade DxCFXBridge contract
    const DxCFXBridgeProxy = await conflux.getContractAt('PoSPoolProxy1967', process.env.CORE_BRIDGE);
    const upgradeReceipt =  await DxCFXBridgeProxy.upgradeTo(DxCFXBridgeImplAddr).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(upgradeReceipt, 'PosPool upgrade');
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});