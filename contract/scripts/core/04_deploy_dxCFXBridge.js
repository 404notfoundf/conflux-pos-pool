const { conflux } = require('hardhat');
const { InitializeMethodData } = require('../../utils/index.js');

async function main() {
    const [deployer] = await conflux.getSigners();

    // deploy DxCFXBridge Contract
    const DxCFXBridge = await conflux.getContractFactory('DxCFXBridge');
    const DxCFXBridgeDeployReceipt = await DxCFXBridge.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const DxCFXBridgeImplAddr = DxCFXBridgeDeployReceipt.contractCreated;
    console.log("=== dx cfx bridge impl address === : ", DxCFXBridgeImplAddr);

    // deploy DxCFXBridge Proxy Contract
    const DxCFXBridgeProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const ProxyDeployReceipt = await DxCFXBridgeProxy.constructor(DxCFXBridgeImplAddr, InitializeMethodData).sendTransaction({
        from: deployer.address,
    }).executed();
    const DxCFXBridgeProxyAddr = ProxyDeployReceipt.contractCreated;
    console.log("=== dx cfx bridge proxy address === : ", DxCFXBridgeProxyAddr);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
