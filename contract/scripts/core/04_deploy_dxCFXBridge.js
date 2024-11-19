const { conflux } = require('hardhat');
const { InitializeMethodData } = require('../../utils/index.js');

const {format} = require('js-conflux-sdk');

async function main() {
    const [deployer] = await conflux.getSigners();

    let bridgeData = `0xc4d66de8000000000000000000000000${format.hexAddress(process.env.OPERATOR_ADDRESS).slice(-40)}`

    // deploy DxCFXBridge Contract
    const DxCFXBridge = await conflux.getContractFactory('DxCFXBridge');
    const DxCFXBridgeDeployReceipt = await DxCFXBridge.constructor().sendTransaction({
        from: deployer.address,
    }).executed();

    const DxCFXBridgeImplAddr = DxCFXBridgeDeployReceipt.contractCreated;
    console.log("=== dx cfx bridge impl address === : ", DxCFXBridgeImplAddr);

    // deploy DxCFXBridge Proxy Contract
    const DxCFXBridgeProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const ProxyDeployReceipt = await DxCFXBridgeProxy.constructor(DxCFXBridgeImplAddr, bridgeData).sendTransaction({
        from: deployer.address,
    }).executed();

    const DxCFXBridgeProxyAddr = ProxyDeployReceipt.contractCreated;
    console.log("=== dx cfx bridge proxy address === : ", DxCFXBridgeProxyAddr);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
