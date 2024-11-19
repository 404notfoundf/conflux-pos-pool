const { conflux } = require('hardhat');
const { logReceipt } = require('../deploy/conflux.js');

async function main(){
    const [deployer] = await conflux.getSigners();

    // deploy votingEscrow contract
    const votingEscrow = await conflux.getContractFactory('VotingEscrow');
    const votingEscrowDeployReceipt = await votingEscrow.constructor().sendTransaction({
        from: deployer.address,
    }).executed();
    const votingEscrowImplAddr = votingEscrowDeployReceipt.contractCreated;
    console.log("=== voting escrow impl address === : ", votingEscrowImplAddr);

    // upgrade new votingEscrow contract
    const votingEscrowProxy = await conflux.getContractAt('PoSPoolProxy1967', process.env.VOTING_ESCROW);
    const upgradeReceipt =  await votingEscrowProxy.upgradeTo(votingEscrowImplAddr).sendTransaction({
        from: deployer.address,
    }).executed();
    logReceipt(upgradeReceipt, "Voting Escrow upgrade");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});