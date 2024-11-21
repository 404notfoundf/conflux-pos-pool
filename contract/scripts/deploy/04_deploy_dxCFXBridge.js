const { conflux } = require('hardhat');
const { InitializeMethodData } = require('../../utils/index.js');

const {format} = require('js-conflux-sdk');

async function main() {
    const [deployer] = await conflux.getSigners();

    let bridgeData = `0xc4d66de8000000000000000000000000${format.hexAddress(process.env.OPERATOR_ADDRESS).slice(-40)}`

    // deploy DxCFXBridge impl  Contract
    const DxCFXBridge = await conflux.getContractFactory('DxCFXBridge');
    const DxCFXBridgeDeployReceipt = await DxCFXBridge.constructor().sendTransaction({
        from: deployer.address,
    }).executed();

    const DxCFXBridgeImplAddress = DxCFXBridgeDeployReceipt.contractCreated;
    console.log("=== cfx bridge impl address === : ", DxCFXBridgeImplAddress);

    // deploy DxCFXBridge proxy Contract
    const DxCFXBridgeProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const ProxyDeployReceipt = await DxCFXBridgeProxy.constructor(DxCFXBridgeImplAddress, bridgeData).sendTransaction({
        from: deployer.address,
    }).executed();

    const DxCFXBridgeProxyAddress = ProxyDeployReceipt.contractCreated;
    console.log("=== cfx bridge proxy address === : ", DxCFXBridgeProxyAddress);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
