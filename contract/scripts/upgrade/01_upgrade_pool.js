const { conflux } = require('hardhat');
const { logReceipt } = require('../deploy/conflux.js');


async function main() {
    const [deployer] = await conflux.getSigners();

    // deploy core space pos pool contract
    const posPool = await conflux.getContractFactory('PoSPool');
    const poolDeployReceipt = await posPool.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const posPoolImplAddr = poolDeployReceipt.contractCreated;
    console.log("=== pos pool impl address === : ", posPoolImplAddr);

    // upgrade new core pos pool contract
    const posPoolProxy = await conflux.getContractAt('PoSPoolProxy1967', process.env.POS_POOL);
    const upgradeReceipt =  await posPoolProxy.upgradeTo(posPoolImplAddr).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(upgradeReceipt, "pos pool upgrade");
}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});