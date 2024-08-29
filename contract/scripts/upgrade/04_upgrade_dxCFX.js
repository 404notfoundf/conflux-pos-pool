const { ethers} = require('hardhat');

async function main() {
    const [deployer] = await ethers.getSigners();

    // deploy DxCFX contract
    const dxCFXFactory = await ethers.getContractFactory('DxCFX');
    const dxCFXImpl = await dxCFXFactory.connect(deployer).deploy();
    await dxCFXImpl.deployed();
    console.log("=== dx cfx impl address === : ", dxCFXImpl.address);

    // upgrade DxCFX contract
    const DxCFX = await ethers.getContractAt('PoSPoolProxy1967', process.env.ESPACE_POOL);
    DxCFX.connect(deployer).upgradeTo(dxCFXImpl.address);
    console.log("upgrade DxCFX finished !!!");

}
//

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});