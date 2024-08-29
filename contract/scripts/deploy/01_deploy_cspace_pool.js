const { conflux } = require('hardhat');
const { InitializeMethodData } = require('../../utils/index.js');
const { logReceipt, Drip } = require('./conflux.js');

async function main() {
    const [deployer] = await conflux.getSigners();
    // deploy pool in proxy mode
    const PoSPool = await conflux.getContractFactory('PoSPool');
    const poolDeployReceipt = await PoSPool.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const posPoolImplAddr = poolDeployReceipt.contractCreated;
    console.log("=== pos pool impl address === : ", posPoolImplAddr);


    const PoSPoolProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const poolProxyDeployReceipt = await PoSPoolProxy.constructor(posPoolImplAddr, InitializeMethodData).sendTransaction({
        from: deployer.address,
    }).executed();

    const posPoolProxyAddr = poolProxyDeployReceipt.contractCreated;
    console.log("=== pos pool proxy address === : ", posPoolProxyAddr);

    // register pool
    const registerPoolReceipt = await conflux.cfx
        .sendTransaction({
            from: deployer.address,
            value: Drip.fromCFX(1000),
            to: posPoolProxyAddr,
            data: process.env.POS_REGIST_DATA,
        })
        .executed();
    logReceipt(registerPoolReceipt, 'PoSPool registration');

    // set pool name
    const posPool = await conflux.getContractAt('PoSPool', posPoolProxyAddr);
    const setPoolNameReceipt = await posPool.setPoolName('DxPool').sendTransaction({
        from: deployer.address,
    }).executed();

    logReceipt(setPoolNameReceipt, 'PosPool set name');
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});