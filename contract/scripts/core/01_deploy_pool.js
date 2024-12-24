const { conflux } = require('hardhat');
const { InitializeMethodData } = require('../../utils/index.js');
const { logReceipt } = require('./conflux.js');

async function main() {
    const [deployer] = await conflux.getSigners();

    // deploy core space pos pool contract
    const poSPool = await conflux.getContractFactory('PoSPool');
    const poolDeployReceipt = await poSPool.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const posPoolImplAddr = poolDeployReceipt.contractCreated;
    console.log("=== pos pool impl address === : ", posPoolImplAddr);

    // deploy core space pos pool proxy contract
    const poSPoolProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const poolProxyDeployReceipt = await poSPoolProxy.constructor(posPoolImplAddr, InitializeMethodData).sendTransaction({
        from: deployer.address,
    }).executed();
    const posPoolProxyAddr = poolProxyDeployReceipt.contractCreated;
    console.log("=== pos pool proxy address === : ", posPoolProxyAddr);


    // register pool for test 暂时不需要
    const registerPoolReceipt = await conflux.cfx
        .sendTransaction({
            from: deployer.address,
            value: Drip.fromCFX(1000),
            to: poolAddress,
            data: process.env.POS_REGISTER_DATA,
        })
        .executed();
    logReceipt(registerPoolReceipt, 'PoSPool registration');


    // set pool name to core space pos pool
    const posPool = await conflux.getContractAt('PoSPool', posPoolProxyAddr);
    const setPoolNameReceipt = await posPool.setPoolName('test').sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setPoolNameReceipt, 'PosPool set name');

    // ======= for test ========
    const setPoolRegisterReceipt = await posPool.setPoolRegistered(true).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setPoolRegisterReceipt, 'PosPool set register')
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});