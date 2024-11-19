const { sign, format, Conflux} = require("js-conflux-sdk");

function loadPrivateKey() {
    if (process.env.PRIVATE_KEY) {
        return process.env.PRIVATE_KEY;
    } else {
        const keystore = require(process.env.KEYSTORE);
        const privateKeyBuf = sign.decrypt(keystore, process.env.KEYSTORE_PWD);
        return format.hex(privateKeyBuf);
    }
}

function loadESpacePrivateKey() {
    if (process.env.ESPACE_PRIVATE_KEY) {
        return process.env.ESPACE_PRIVATE_KEY;
    } else {
        const keystore = require(process.env.KEYSTORE);
        const privateKeyBuf = sign.decrypt(keystore, process.env.KEYSTORE_PWD);
        return format.hex(privateKeyBuf);
    }
}

// proxy1967 initialize(no params) method data
const InitializeMethodData = '0x8129fc1c';

// 关于CoreSpace
const cfxInstance = new Conflux({
    url: process.env.CFX_RPC_URL,
    networkId: parseInt(process.env.CFX_NETWORK_ID)
})

const cfxAccount = cfxInstance.wallet.addPrivateKey(loadPrivateKey())


// 关于eSpace
const eSpaceInstance = new Conflux({
    url: process.env.ESPACE_RPC_URL,
    networkId: parseInt(process.env.ESPACE_NETWORK_ID)
})

const eSpaceAccount = eSpaceInstance.wallet.addPrivateKey(loadESpacePrivateKey())


module.exports = {
    cfxInstance,
    cfxAccount,
    eSpaceInstance,
    eSpaceAccount,
    loadPrivateKey,
    loadESpacePrivateKey,
    InitializeMethodData,
};
