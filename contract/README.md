## 部署 Core Space 相关合约
1. 修改 env 中 CFX_RPC_URL, CFX_NETWORK_ID, PRIVATE_KEY

2. 执行相关指令
   1. 进入contract目录
   ```shell
      cd contract 
   ```
   2. 安装node相关库
      npm install
   
   3. 编译整个合约
   ```shell
      npx hardhat compile
   ```
   
 **(注：主网部署需要将配置文件中 CFX_RPC_URL, NETWORK_ID 替换成主网, 同时部署命令中将 cfx_testnet 替换成 cfx , espace_testnet 替换成 espace 即可)** 

   4. 部署core Space PosPool 合约
   ```shell
      npx hardhat run scripts/deploy/01_deploy_pool.js --network cfx_testnet
   ```
   将部署后的合约地址填入 env 文件中 POS_POOL 字段

   5. 部署 VotingEscrow 合约
   ```shell
      npx hardhat run scripts/deploy/02_deploy_votingEscrow.js --network cfx_testnet
   ```   
  
   部署后的 VotingEscrow合约 填入 VOTING_ESCROW 字段

3. 需要手动验证合约, 且不支持多个文件拆分

## 部署 ESpace 小额质押相关合约
1. 填充 env 中 ESPACE_RPC_URL, ESPACE_NETWORK_ID, ESPACE_PRIVATE_KEY, OPERATOR_ADDRESS 字段 
2. 部署 POS_ORACLE 合约
```shell
   npx hardhat run scripts/deploy/03_deploy_posOracle.js --network cfx_testnet
```
将部署后的合约地址填入 env 文件中 POS_ORACLE 字段

3. 部署 CoreBridge 合约
```shell
   npx hardhat run scripts/deploy/04_deploy_dxCFXBridge.js --network cfx_testnet
```
并将部署后的合约地址填入 env 文件中 CORE_BRIDGE 字段 

4. 部署 DxCFX 合约
```shell
   npx hardhat run scripts/deploy/05_deploy_dxCFX.js --network espace_testnet
```
并将部署后的合约地址填入 env 文件中 ESPACE_POOL 字段

5. 设置 CoreBridge 合约相关参数
```shell
   npx hardhat run scripts/deploy/06_set_dxCFXBridge.js --network cfx_testnet
```

(注: 主网部署需要将配置文件相关部分替换成主网，同时部署命令中的cfx_testnet 替换成 cfx, espace_testnet 替换成 espace)


## 升级合约
1. 升级 coreSpace 的 posPool 合约
```shell
   npx hardhat run scripts/upgrade/01_upgrade_pool.js --network cfx_testnet
```

2. 升级 VotingEscrow 合约
```shell
   npx hardhat run scripts/upgrade/02_upgrade_votingEscrow.js --network cfx_testnet
```

3. 升级 DxCFXBridge 合约
```shell
   npx hardhat run scripts/upgrade/03_upgrade_dxCFXBridge.js --network cfx_testnet
```

4. 升级 DxCFX 合约
```shell
   npx hardhat run scripts/upgrade/04_upgrade_dxCFX.js --network espace_testnet
```