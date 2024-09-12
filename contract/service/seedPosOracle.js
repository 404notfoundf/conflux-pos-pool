/* eslint-disable node/no-unsupported-features/es-syntax */
/* eslint-disable node/no-unpublished-require */
/* eslint-disable prefer-const */
/* eslint-disable no-unused-vars */
/* eslint-disable prettier/prettier */
require('dotenv').config();
const {cfxAccount, cfxInstance} = require("../utils");
const { POS_POOL, POS_POOL_POS_ACCOUNT } = process.env;
const PosOracleInfo = require("../artifacts/contracts/cspace/PosOracle.sol/PoSOracle.json");


const oracle = cfxInstance.Contract({
    abi: PosOracleInfo.abi,
    address: process.env.POS_ORACLE
});

// posAddress即validator的地址, powAddress地址即core Space合约地址
async function main() {
    setInterval(async function () {
        await updatePosRewardInfo();
    }, 1000 * 60 * 15.5);

    setInterval(async function () {
        await updatePosAccountInfo();
    }, 1000 * 60 * 13.5);

    console.log("=== start pos oracle service ===");
}

async function updatePosRewardInfo(epoch) {
    try {
        if (!epoch) {
            const status = await cfxInstance.pos.getStatus();
            epoch = status.epoch - 1;
        }

        console.log(`Updating epoch ${epoch} reward info`);

        const rewardInfo = await cfxInstance.pos.getRewardsByEpoch(epoch);
        if (!rewardInfo || !rewardInfo.accountRewards) return;
        const {accountRewards} = rewardInfo;

        console.log("account reward info : ", accountRewards)

        // 即比较Core Space地址与powAddress地址是否相同
        let target = accountRewards.find(
            (r) =>
                r.powAddress.toLowerCase() ===
                POS_POOL.toLowerCase()
        );
        if (!target) {
            console.log(`No reward info for ${POS_POOL}`);
            return;
        }
        const receipt = await oracle
            .updatePoSRewardInfo(
                epoch,
                target.powAddress,
                target.posAddress,
                target.reward
            )
            .sendTransaction({
                from: cfxAccount.address,
            })
            .executed();

        console.log(new Date(), "success updatePosRewardInfo, tx hash is : ", receipt.transactionHash); // log record update reward info
    } catch (e) {
        console.error(new Date(), "fail updatePosRewardInfo , error is : ", e);
    }
}

async function updatePosAccountInfo() {
    try {
        const status = await cfxInstance.pos.getStatus();
        const accountInfo = await cfxInstance.pos.getAccount(POS_POOL_POS_ACCOUNT);
        if (!accountInfo) return;
        const {
            address,
            blockNumber,
            status: {
                inQueue,
                outQueue,
                locked,
                unlocked,
                availableVotes,
                forceRetired,
                forfeited,
            },
        } = accountInfo;

        const receipt = await oracle
            .updatePoSAccountInfo(
                address,
                status.epoch,
                blockNumber,
                availableVotes,
                unlocked,
                locked,
                forfeited,
                !!forceRetired,
                inQueue,
                outQueue
            )
            .sendTransaction({
                from: cfxAccount.address,
            })
            .executed();

        console.log(new Date(), "success updatePosAccountInfo, tx hash is : ", receipt.transactionHash); // log success update transaction hash
    } catch (e) {
        console.error(new Date(), "fail updatePosAccountInfo, error is : ", e);
    }
}

main().catch(console.log);
