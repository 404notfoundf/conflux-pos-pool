const { conflux } = require('hardhat');
const { InitializeMethodData } = require('../../utils/index.js');
const { logReceipt,Drip } = require('./conflux.js');

async function main() {
    const [deployer] = await conflux.getSigners();

    // deploy core space pos pool impl contract
    const poSPool = await conflux.getContractFactory('PoSPool');
    const poolDeployReceipt = await poSPool.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const posPoolImplAddr = poolDeployReceipt.contractCreated;
    console.log("=== pos pool address === : ", posPoolImplAddr);

    // deploy core space pos pool proxy contract
    const poSPoolProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const poolProxyDeployReceipt = await poSPoolProxy.constructor(posPoolImplAddr, InitializeMethodData).sendTransaction({
        from: deployer.address,
    }).executed();
    const posPoolProxyAddr = poolProxyDeployReceipt.contractCreated;
    console.log("=== pos pool proxy address === : ", posPoolProxyAddr);

    // register pool
    const registerPoolReceipt = await conflux.cfx
        .sendTransaction({
            from: deployer.address,
            value: Drip.fromCFX(1000),
            to: poSPoolProxy,
            data: process.env.POS_REGISTER_DATA,
        })
        .executed();
    logReceipt(registerPoolReceipt, 'PoSPool registration');

    // set pool name to core space pos pool
    const posPool = await conflux.getContractAt('PoSPool', posPoolProxyAddr);
    const setPoolNameReceipt = await posPool.setPoolName('Dxpool CFX').sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setPoolNameReceipt, 'PosPool set name');
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});