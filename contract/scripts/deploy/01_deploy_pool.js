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
    const posPoolImplAddress = poolDeployReceipt.contractCreated;

    console.log("=== pos pool impl address === : ", posPoolImplAddress);

    // deploy core space pos pool proxy contract
    const poSPoolProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const poolProxyDeployReceipt = await poSPoolProxy.constructor(posPoolImplAddress, InitializeMethodData).sendTransaction({
        from: deployer.address,
    }).executed();
    const posPoolProxyAddress = poolProxyDeployReceipt.contractCreated;
    console.log("=== pos pool proxy address === : ", posPoolProxyAddress);

    // register pool
    const registerPoolReceipt = await conflux.cfx
        .sendTransaction({
            from: deployer.address,
            value: Drip.fromCFX(1000),
            to: posPoolProxyAddress,
            data: process.env.POS_REGISTER_DATA,
        })
        .executed();
    logReceipt(registerPoolReceipt, 'PoSPool registration');

    // set pool name to core space pos pool
    const posPool = await conflux.getContractAt('PoSPool', posPoolProxyAddress);
    const setPoolNameReceipt = await posPool.setPoolName('Dxpool CFX').sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setPoolNameReceipt, 'PosPool set name');
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});