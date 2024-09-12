/* eslint-disable node/no-unsupported-features/es-syntax */
/* eslint-disable node/no-unpublished-require */
/* eslint-disable prefer-const */
/* eslint-disable no-unused-vars */
/* eslint-disable prettier/prettier */
require('dotenv').config();
const { Drip } = require("js-conflux-sdk");
const {cfxInstance, cfxAccount} = require("../utils");
const {logReceipt} = require("../scripts/core/conflux");
const bridgeInfo = require("../artifacts/contracts/cspace/DxCFXBridge.sol/DxCFXBridge.json")

const dxCfxBridge = cfxInstance.Contract({
        abi: bridgeInfo.abi,
        address: process.env.CORE_BRIDGE,
    })

const ONE_VOTE_CFX = BigInt(Drip.fromCFX(1000));

async function main() {
    setInterval(async () => {
        try {
            await handleCrossSpaceTask();
        } catch (e) {
            console.error("handleCrossSpaceTask error: ", e);
        }
    }, 1000 * 60 * 2);

    console.log("=== start handle cross space task ===");
}

main().catch(console.log);

async function handleCrossSpaceTask() {
    // 1. cfx 从 eSpace -> core space
    const mappedBalance = await dxCfxBridge.mappedBalance();
    console.log("mappedBalance : ", mappedBalance);

    if (mappedBalance > 0) {
        const receipt = await dxCfxBridge.transferFromEspace().sendTransaction({
            from: cfxAccount.address,
        }).executed();

        logReceipt(receipt, "cross cfx from eSpace to core space");
    }

    // 2. 查看在此期间有多少收益, 领取, 发送到eSpace
    const reward = await dxCfxBridge.poolReward();
    console.log("reward : ", reward);

    if (reward > 0) {
        const receipt = await dxCfxBridge.claimReward().sendTransaction({
            from: cfxAccount.address,
        }).executed();

        logReceipt(receipt, "claim reward");
    }

    // 3. 查看有多少redeem
    const redeemLen = await dxCfxBridge.eSpaceRedeemLen();
    console.log("redeemLen : ", redeemLen);

    /*
        如果需要 redeem , 处理流程如下:
        1. 查看是否有unlocked, 直接withdraw
        2. 查看是否有unlocking(在解锁中的)
        3. 查看是否需要从正在stake中的退出, 以及计算应该退多少
    */
    if (redeemLen > 0) {

        let summary = await dxCfxBridge.poolSummary();
        // 查看是否有, 直接处理
        if (summary.unlounlockedcked > 0) {
            await _handleRedeem();
            summary = await dxCfxBridge.poolSummary();
        }

        let balance = await cfxInstance.cfx.getBalance(process.env.CORE_BRIDGE);
        let unlocking = summary.votes - summary.available - summary.unlocked;
        let totalNeedRedeem = await dxCfxBridge.eSpacePoolTotalRedeemed();
        console.log("totalNeedRedeem : ", totalNeedRedeem);

        if (
            summary.locked > 0 &&
            balance + unlocking * ONE_VOTE_CFX < totalNeedRedeem
        ) {
            await _handleRedeem();
        }

        if (balance > totalNeedRedeem) {
            await _handleRedeem();
        }

    } else {

        let summary = await dxCfxBridge.poolSummary();
        if (summary.unlocked > 0) {
            await _handleRedeem(); // withdraw
            summary = await dxCfxBridge.poolSummary();
        }

        let balance = await cfxInstance.cfx.getBalance(process.env.CORE_BRIDGE);
        let accReward = await dxCfxBridge.poolAccReward();

        if (accReward > balance) {
            let unlocking = summary.votes - summary.available - summary.unlocked;
            if (accReward > balance + unlocking * ONE_VOTE_CFX) {
                let toUnlock = accReward - balance - unlocking * ONE_VOTE_CFX;
                let toUnlockVote = toUnlock / ONE_VOTE_CFX;
                if (toUnlock > toUnlockVote * ONE_VOTE_CFX) toUnlockVote += 1n;
                if (toUnlockVote > 0) {
                    const receipt = await dxCfxBridge
                        .unstakeVotes(toUnlockVote)
                        .sendTransaction({
                            from: cfxAccount.address,
                        })
                        .executed();
                    logReceipt(receipt, "unstake votes");
                }
            }
        }
    }

    // 4. 质押多余的部分
    const stakeAbleBalance = await dxCfxBridge.stakeAbleBalance();
    console.log("stakeAbleBalance : ", stakeAbleBalance);
    if (stakeAbleBalance > ONE_VOTE_CFX) {
        const receipt = await dxCfxBridge.stakeVotes().sendTransaction({
            from: cfxAccount.address,
        }).executed();
        logReceipt(receipt, "stake votes");
    }
}

async function _handleRedeem() {
    try {
        const receipt = await dxCfxBridge
            .handleRedeem()
            .sendTransaction({
                from: cfxAccount.address,
            })
            .executed();
        logReceipt(receipt, "handle redeem");
    } catch (error) {
        console.error("handle redeem error: ", error);
    }
}