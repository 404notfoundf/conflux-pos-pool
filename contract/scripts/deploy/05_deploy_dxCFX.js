const { ethers } = require('hardhat');
const { InitializeMethodData } = require('../../utils/index.js');
const { address } = require("js-conflux-sdk");

async function main() {
    const [deployer] = await ethers.getSigners();

    // deploy DxCFX impl contract
    const dxCFXFactory = await ethers.getContractFactory('DxCFX');
    const dxCFXImpl = await dxCFXFactory.connect(deployer).deploy();
    await dxCFXImpl.deployed();
    console.log("=== DxCFX Token impl address === : ", dxCFXImpl.address);

    // deploy DxCFX proxy contract
    const dxCFXProxyFactory = await ethers.getContractFactory('PoSPoolProxy1967');
    const dxCFXProxy = await dxCFXProxyFactory.connect(deployer).deploy(dxCFXImpl.address, InitializeMethodData);
    await dxCFXProxy.deployed();
    console.log("=== DxCFX Token proxy address === : ", dxCFXProxy.address);

    // set core bridge address
    const dxCFX = await ethers.getContractAt('DxCFX', dxCFXProxy.address);
    const transaction = await dxCFX.connect(deployer).setCoreBridge(address.cfxMappedEVMSpaceAddress(process.env.CORE_BRIDGE));
    await transaction.wait();
    console.log(`${deployer.address} set core bridge to dxCfx`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});