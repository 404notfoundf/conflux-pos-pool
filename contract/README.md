### 修改配置文件和构建环境
1. 进入contract目录
   ```shell
      cd contract
   ```
2. 修改配置文件
   
   如果是正式网
   ```shell
      cp .env.mainnet.example .env
   ```

   如果是测试网
   ```shell
      cp .env.testnet.example .env
   ```
3. 安装node库
    ```shell
      npm install
   ```
4. 编译合约
   ```shell
      npx hardhat compile
   ```

### 部署 Core Space 相关合约
1. 填入.env文件中 PRIVATE_KEY, POS_REGISTER_DATA 字段

**注: 如果是主网部署的话, 将部署命令中的 cfx_testnet 替换成 cfx , espace_testnet 替换成 espace 即可**

2. 部署 core Space PosPool 合约
   ```shell
      npx hardhat run scripts/deploy/01_deploy_pool.js --network cfx_testnet
   ```
   将部署后的合约地址填入 .env文件中 POS_POOL 字段

3. 部署 VotingEscrow 合约
   ```shell
      npx hardhat run scripts/deploy/02_deploy_votingEscrow.js --network cfx_testnet
   ```
   将部署后的合约地址填入 .env文件中 VOTING_ESCROW 字段


### 部署 ESpace 小额质押相关合约
需要先部署Core Space相关合约, 填入 .env文件中的 POS_POOL, VOTING_ESCROW 字段

1. 填入 .env文件中 PRIVATE_KEY, ESPACE_PRIVATE_KEY, OPERATOR_ADDRESS 字段

**注: 如果是主网部署的话, 将部署命令中的 cfx_testnet 替换成 cfx , espace_testnet 替换成 espace 即可**

2. 部署 posOracle 合约
```shell
   npx hardhat run scripts/deploy/03_deploy_posOracle.js --network cfx_testnet
```
将部署后的合约地址填入 .env 文件中 POS_ORACLE 字段

3. 部署 DxCfxBridge 合约
```shell
   npx hardhat run scripts/deploy/04_deploy_dxCFXBridge.js --network cfx_testnet
```
将部署后的合约地址填入 .env 文件中 CORE_BRIDGE 字段

4. 部署 DxCfx 合约
```shell
   npx hardhat run scripts/deploy/05_deploy_dxCFX.js --network espace_testnet
```
将部署后的合约地址填入 .env 文件中 ESPACE_POOL 字段

5. 设置 DxCfxBridge 合约相关参数
```shell
   npx hardhat run scripts/deploy/06_set_dxCFXBridge.js --network cfx_testnet
```

### 升级合约
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