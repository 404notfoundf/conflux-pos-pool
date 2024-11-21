const { conflux } = require('hardhat');
const { logReceipt } = require('./conflux.js');
const { InitializeMethodData } = require('../../utils/index.js');

async function main() {
    const [deployer] = await conflux.getSigners();

    // deploy votingEscrow impl contract
    const VotingEscrow = await conflux.getContractFactory('VotingEscrow');
    const votingEscrowDeployReceipt = await VotingEscrow.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const votingEscrowImplAddress = votingEscrowDeployReceipt.contractCreated;
    console.log("=== votingEscrow impl address === : ", votingEscrowImplAddress);

    // deploy votingEscrow proxy contract
    const PoSPoolProxy = await conflux.getContractFactory('PoSPoolProxy1967');
    const proxyDeployReceipt = await PoSPoolProxy.constructor(votingEscrowImplAddress, InitializeMethodData).sendTransaction({
        from: deployer.address,
    }).executed();
    const votingEscrowProxyAddress = proxyDeployReceipt.contractCreated;
    console.log("=== votingEscrow proxy address === : ", votingEscrowProxyAddress);


    // set core space pos pool to votingEscrow contract
    const votingEscrow = await conflux.getContractAt('VotingEscrow', votingEscrowProxyAddress);
    const setPoSPoolReceipt = await votingEscrow.setPosPool(process.env.POS_POOL).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setPoSPoolReceipt, 'VotingEscrow.setPoSPool');

    // set votingEscrow to core space pos pool contract
    const posPool = await conflux.getContractAt('PoSPool', process.env.POS_POOL);
    const setVotingEscrowReceipt = await posPool.setVotingEscrow(votingEscrowProxyAddress).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(setVotingEscrowReceipt, 'PoSPool.setVotingEscrow');

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});