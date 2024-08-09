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
    const logicAddress = poolDeployReceipt.contractCreated;
    logReceipt('Pos Pool logic address: ', logicAddress);


    const PoSPoolProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const poolProxyDeployReceipt = await PoSPoolProxy.constructor(poolDeployReceipt.contractCreated, InitializeMethodData).sendTransaction({
        from: deployer.address,
    }).executed();

    const poolAddress = poolProxyDeployReceipt.contractCreated;
    console.log('PoSPool address: ', poolAddress);

    /*
    // register pool
    const registerPoolReceipt = await conflux.cfx
        .sendTransaction({
            from: deployer.address,
            value: Drip.fromCFX(1000),
            to: poolAddress,
            data: process.env.POS_REGIST_DATA,
        })
        .executed();
    logReceipt(registerPoolReceipt, 'PoSPool registration');
     */

    // set pool name
    const posPool = await conflux.getContractAt('PoSPool', poolAddress);
    const setPoolNameReceipt = await posPool.setPoolName('test_A').sendTransaction({
        from: deployer.address,
    }).executed();

    logReceipt(setPoolNameReceipt, 'PosPool set name');

    // for test
    const setPoolRegisterReceipt = await posPool.setPoolRegistered(true).sendTransaction({
        from: deployer.address,
    }).executed();

    logReceipt(setPoolRegisterReceipt, 'PosPool set register')
    /*
    // add posPool to poolManager
    const poolManagerAddr = process.env.POOL_MANAGER_ADDRESS;
    const poolManager = await conflux.getContractAt('PoolManager', poolManagerAddr);
    const addReceipt = await poolManager.addPool(poolAddress).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(addReceipt, 'PoSPool added to PoolManager');
     */
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});