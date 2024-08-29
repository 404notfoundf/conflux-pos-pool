const { ethers } = require('hardhat');
const { InitializeMethodData } = require('../../utils/index.js');
const { address } = require("js-conflux-sdk");

async function main() {
    const [deployer] = await ethers.getSigners();

    // deploy DxCFX contract
    const dxCFXFactory = await ethers.getContractFactory('DxCFX');
    const dxCFXImpl = await dxCFXFactory.connect(deployer).deploy();
    await dxCFXImpl.deployed();
    console.log("=== dx cfx impl address === : ", dxCFXImpl.address);

    // deploy DxCFX Proxy contract
    const dxCFXProxyFactory = await ethers.getContractFactory('PoSPoolProxy1967');
    const dxCFXProxy = await dxCFXProxyFactory.connect(deployer).deploy(dxCFXImpl.address, InitializeMethodData);
    await dxCFXProxy.deployed();
    console.log("=== dx cfx proxy address === : ", dxCFXProxy.address);

    // set core space address
    const dxCFX = await ethers.getContractAt('DxCFX', dxCFXProxy.address);
    const tx = await dxCFX.connect(deployer).setCoreBridge(address.cfxMappedEVMSpaceAddress(process.env.CORE_BRIDGE));
    await tx.wait();
    console.log(`${deployer.address} set core bridge to dxCfx`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});