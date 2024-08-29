//SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/proxy/utils/Initializable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.20;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Storage of the initializable contract.
     *
     * It's implemented on a custom ERC-7201 namespace to reduce the risk of storage collisions
     * when using with upgradeable contracts.
     *
     * @custom:storage-location erc7201:openzeppelin.storage.Initializable
     */
    struct InitializableStorage {
        /**
         * @dev Indicates that the contract has been initialized.
         */
        uint64 _initialized;
        /**
         * @dev Indicates that the contract is in the process of being initialized.
         */
        bool _initializing;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Initializable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant INITIALIZABLE_STORAGE = 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00;

    /**
     * @dev The contract is already initialized.
     */
    error InvalidInitialization();

    /**
     * @dev The contract is not initializing.
     */
    error NotInitializing();

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint64 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that in the context of a constructor an `initializer` may be invoked any
     * number of times. This behavior in the constructor can be useful during testing and is not expected to be used in
     * production.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        // Cache values to avoid duplicated sloads
        bool isTopLevelCall = !$._initializing;
        uint64 initialized = $._initialized;

        // Allowed calls:
        // - initialSetup: the contract is not in the initializing state and no previous version was
        //                 initialized
        // - construction: the contract is initialized at version 1 (no reininitialization) and the
        //                 current contract is just being deployed
        bool initialSetup = initialized == 0 && isTopLevelCall;
        bool construction = initialized == 1 && address(this).code.length == 0;

        if (!initialSetup && !construction) {
            revert InvalidInitialization();
        }
        $._initialized = 1;
        if (isTopLevelCall) {
            $._initializing = true;
        }
        _;
        if (isTopLevelCall) {
            $._initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: Setting the version to 2**64 - 1 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint64 version) {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing || $._initialized >= version) {
            revert InvalidInitialization();
        }
        $._initialized = version;
        $._initializing = true;
        _;
        $._initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        _checkInitializing();
        _;
    }

    /**
     * @dev Reverts if the contract is not in an initializing state. See {onlyInitializing}.
     */
    function _checkInitializing() internal view virtual {
        if (!_isInitializing()) {
            revert NotInitializing();
        }
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing) {
            revert InvalidInitialization();
        }
        if ($._initialized != type(uint64).max) {
            $._initialized = type(uint64).max;
            emit Initialized(type(uint64).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint64) {
        return _getInitializableStorage()._initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _getInitializableStorage()._initializing;
    }

    /**
     * @dev Returns a pointer to the storage namespace.
     */
    // solhint-disable-next-line var-name-mixedcase
    function _getInitializableStorage() private pure returns (InitializableStorage storage $) {
        assembly {
            $.slot := INITIALIZABLE_STORAGE
        }
    }
}

// File: @confluxfans/contracts/InternalContracts/ParamsControl.sol



pragma solidity >=0.8.0;

interface ParamsControl {
    struct Vote {
        uint16 topic_index;
        uint256[3] votes;
    }

    /*** Query Functions ***/
    /**
     * @dev cast vote for parameters
     * @param vote_round The round to vote for
     * @param vote_data The list of votes to cast
     */
    function castVote(uint64 vote_round, Vote[] calldata vote_data) external;

    /**
     * @dev read the vote data of an account
     * @param addr The address of the account to read
     */
    function readVote(address addr) external view returns (Vote[] memory);

    /**
     * @dev Current vote round
     */
    function currentRound() external view returns (uint64);

    /**
     * @dev read the total votes of given round
     * @param vote_round The vote number
     */
    function totalVotes(uint64 vote_round) external view returns (Vote[] memory);

    /**
     * @dev read the PoS stake for the round.
     */
    function posStakeForVotes(uint64) external view returns (uint256);

    event CastVote(uint64 indexed vote_round, address indexed addr, uint16 indexed topic_index, uint256[3] votes);
    event RevokeVote(uint64 indexed vote_round, address indexed addr, uint16 indexed topic_index, uint256[3] votes);
}

// File: contracts/utils/VotePowerQueue.sol


pragma solidity ^0.8.20;

library VotePowerQueue {

    struct QueueNode {
        uint256 votePower;
        uint256 endBlock;
    }

    struct InOutQueue {
        uint256 start;
        uint256 end;
        mapping(uint256 => QueueNode) items;
    }

    function enqueue(InOutQueue storage queue, QueueNode memory item) internal {
        queue.items[queue.end++] = item;
    }

    function dequeue(InOutQueue storage queue) internal returns (QueueNode memory) {
        QueueNode memory item = queue.items[queue.start];
        delete queue.items[queue.start++];
        return item;
    }

    function queueItems(InOutQueue storage q) internal view returns (QueueNode[] memory) {
        QueueNode[] memory items = new QueueNode[](q.end - q.start);
        for (uint256 i = q.start; i < q.end; i++) {
            items[i - q.start] = q.items[i];
        }
        return items;
    }

    function queueItems(InOutQueue storage q, uint64 offset, uint64 limit) internal view returns (QueueNode[] memory) {
        uint256 start = q.start + offset;
        if (start >= q.end) {
            return new QueueNode[](0);
        }
        uint end = start + limit;
        if (end > q.end) {
            end = q.end;
        }
        QueueNode[] memory items = new QueueNode[](end - start);
        for (uint256 i = start; i < end; i++) {
            items[i - start] = q.items[i];
        }
        return items;
    }

    /**
    * Collect all ended vote powers from queue
    */
    function collectEndedVotes(InOutQueue storage q) internal returns (uint256) {
        uint256 total = 0;
        for (uint256 i = q.start; i < q.end; i++) {
            if (q.items[i].endBlock > block.number) {
                break;
            }
            total += q.items[i].votePower;
            dequeue(q);
        }
        return total;
    }

    function sumEndedVotes(InOutQueue storage q) internal view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = q.start; i < q.end; i++) {
            if (q.items[i].endBlock > block.number) {
                break;
            }
            total += q.items[i].votePower;
        }
        return total;
    }

    function clear(InOutQueue storage q) internal {
        for (uint256 i = q.start; i < q.end; i++) {
            delete q.items[i];
        }
        q.start = q.end;
    }

}
// File: contracts/interfaces/IVotingEscrow.sol


pragma solidity ^0.8.20;


interface IVotingEscrow {
    struct LockInfo {
        uint256 amount;
        uint256 unlockBlock;
    }

    function userStakeAmount(address user) external view returns (uint256);

    function createLock(uint256 amount, uint256 unlockBlock) external;
    function increaseLock(uint256 amount) external;
    function extendLockTime(uint256 unlockBlock) external;

    function userLockInfo(address user) external view returns (LockInfo memory);
    function userLockInfo(address user, uint256 blockNumber) external view returns (LockInfo memory);

    function userVotePower(address user) external view returns (uint256);
    function userVotePower(address user, uint256 blockNumber) external view returns (uint256);

    function castVote(uint64 vote_round, uint16 topic_index, uint256[3] memory votes) external;
    function readVote(address addr, uint16 topicIndex) external view returns (ParamsControl.Vote memory);

    function triggerLock() external;
    function triggerVote() external;

    event VoteLock(uint256 indexed amount, uint256 indexed unlockBlock);
    event CastVote(address indexed user, uint256 indexed round, uint256 indexed topicIndex, uint256[3] votes);
}
// File: contracts/interfaces/IPoSPool.sol

pragma solidity ^0.8.20;

interface IPoSPool {
    struct PoolSummary {
        uint256 available;
        uint256 interest;
        uint256 totalInterest; // total interest of all pools
    }

    struct UserSummary {
        uint256 votes;  // Total votes in PoS system, including locking, locked, unlocking, unlocked
        uint256 available; // locking + locked
        uint256 locked;
        uint256 unlocked;
        uint256 claimedInterest;
        uint256 currentInterest;
    }

    struct PoolShot {
        uint256 available;
        uint256 balance;
        uint256 blockNumber;
    }

    struct UserShot {
        uint256 available;
        uint256 accRewardPerCfx;
        uint256 blockNumber;
    }

    // admin functions
    function register(bytes32 identifier, uint64 votePower, bytes calldata blsPubKey, bytes calldata vrfPubKey, bytes[2] calldata blsPubKeyProof) external payable;
    function setPoolUserShareRatio(uint32 ratio) external;
    function setLockPeriod(uint64 period) external;
    function setPoolName(string memory name) external;
    function reStake(uint64 votePower) external;

    // pool info
    function poolSummary() external view returns (PoolSummary memory);
    function poolAPY() external view returns (uint32);
    function poolUserShareRatio() external view returns (uint64); // will return pool general user share ratio
    // function userShareRatio() external view returns (uint64);  // will return user share ratio according feeFreeWhiteList
    function poolName() external view returns (string memory);
    function _poolLockPeriod() external view returns (uint64);

    // user functions
    function increaseStake(uint64 votePower) external payable;
    function decreaseStake(uint64 votePower) external;
    function withdrawStake(uint64 votePower) external;
    function getUserReward(address _address) external view returns (uint256);
    function claimReward(uint256 amount) external;
    function claimAllReward() external;
    function userSummary(address _user) external view returns (UserSummary memory);
    function posAddress() external view returns (bytes32);
    function userInQueue(address account) external view returns (VotePowerQueue.QueueNode[] memory);
    function userOutQueue(address account) external view returns (VotePowerQueue.QueueNode[] memory);
    function userInQueue(address account, uint64 offset, uint64 limit) external view returns (VotePowerQueue.QueueNode[] memory);
    function userOutQueue(address account, uint64 offset, uint64 limit) external view returns (VotePowerQueue.QueueNode[] memory);

    function lockForVotePower(uint256 amount, uint256 unlockBlockNumber) external;
    function castVote(uint64 vote_round, ParamsControl.Vote[] calldata vote_data) external;
    function userLockInfo(address user) external view returns (IVotingEscrow.LockInfo memory);
    function votingEscrow() external view returns (address);
    function userVotePower(address user) external view returns (uint256);
}
// File: contracts/interfaces/IPoSOracle.sol


pragma solidity ^0.8.20;

interface IPoSOracle {
    struct VoteInfo {
        uint256 power;
        uint256 endBlockNumber; // end PoS block number
    }

    struct RewardInfo {
        bytes32 posAddress;
        address powAddress;
        uint256 reward;
    }

    struct PoSAccountInfo {
        uint256 epochNumber; // pos epoch number
        uint256 blockNumber; // pos block number
        uint256 availableVotes;
        uint256 unlocked;
        uint256 locked;
        uint256 forfeited;
        bool forceRetired;
        VoteInfo[] inQueue;
        VoteInfo[] outQueue;
    }

    function posBlockHeight() external view returns (uint256);
    function posEpochHeight() external view returns (uint256);
    function powEpochNumber() external view returns (uint256);
    function getUserVotes(uint256 epoch, address posAddr) external view returns (uint256);
    function getUserPoSReward(uint256 epoch, address posAddr) external view returns (uint256);
    function getPoSAccountInfo(bytes32 posAddr) external view returns (PoSAccountInfo memory);
    function getPoSAccountInfo(address powAddr) external view returns (PoSAccountInfo memory);
}

// File: @confluxfans/contracts/InternalContracts/CrossSpaceCall.sol


pragma solidity >=0.5.0;

// CrossSpaceCall address is: 0x0888000000000000000000000000000000000006

interface CrossSpaceCall {
    event Call(bytes20 indexed sender, bytes20 indexed receiver, uint256 value, uint256 nonce, bytes data);

    event Create(bytes20 indexed sender, bytes20 indexed contract_address, uint256 value, uint256 nonce, bytes init);

    event Withdraw(bytes20 indexed sender, address indexed receiver, uint256 value, uint256 nonce);

    event Outcome(bool success);

    function createEVM(bytes calldata init) external payable returns (bytes20);

    function transferEVM(bytes20 to) external payable returns (bytes memory output);

    function callEVM(bytes20 to, bytes calldata data) external payable returns (bytes memory output);

    function staticCallEVM(bytes20 to, bytes calldata data) external view returns (bytes memory output);

    function deployEip1820() external;

    function withdrawFromMapped(uint256 value) external;

    function mappedBalance(address addr) external view returns (uint256);

    function mappedNonce(address addr) external view returns (uint256);
}

// File: contracts/SpaceBridge.sol


pragma solidity ^0.8.20;




/**
 * @dev SpaceBridge is a PoS bridge contract for eSpace PoS pool contract. Can transfer CFX between Conflux eSpace and Core.
 */
contract SpaceBridge is Ownable {
    constructor() Ownable(msg.sender) {
    }

    CrossSpaceCall internal constant CROSS_SPACE_CALL = CrossSpaceCall(0x0888000000000000000000000000000000000006);
    uint256 public constant CFX_PER_VOTE = 1000 ether;
    uint256 public constant RATIO_BASE = 1000_000_000;

    IPoSPool internal posPoolInterface;
    address public posPoolAddr;
    address public eSpacePoolAddr;

    function setPoSPool(address poolAddress) public onlyOwner {
        posPoolAddr = poolAddress;
        posPoolInterface = IPoSPool(poolAddress);
    }

    function setESpacePool(address eSpacePoolAddress) public onlyOwner {
        eSpacePoolAddr = eSpacePoolAddress;
    }

    function transferToEspacePool(uint256 amount) public onlyOwner {
        require(amount <= _balance(), "insufficient balance");
        CROSS_SPACE_CALL.transferEVM{value: amount}(_ePoolAddrB20());
    }

    function transferToEspacePool() public onlyOwner {
        uint256 _amount = _balance();
        CROSS_SPACE_CALL.transferEVM{value: _amount}(_ePoolAddrB20());
    }

    function transferFromEspace(uint256 amount) public onlyOwner {
        require(mappedBalance() >= amount, "insufficient balance");
        CROSS_SPACE_CALL.withdrawFromMapped(amount);
    }

    function transferFromEspace() public onlyOwner {
        uint256 _amount = mappedBalance();
        CROSS_SPACE_CALL.withdrawFromMapped(_amount);
    }

    function poolReward() public view returns (uint256) {
        uint256 reward = posPoolInterface.getUserReward(address(this));
        return reward;
    }

    function poolSummary() public view returns (IPoSPool.UserSummary memory) {
        IPoSPool.UserSummary memory userSummary = posPoolInterface.userSummary(address(this));
        return userSummary;
    }

    function mappedBalance() public view returns (uint256) {
        return CROSS_SPACE_CALL.mappedBalance(address(this));
    }

    function _balance() internal view returns (uint256) {
        return address(this).balance;
    }

    function _ePoolAddrB20() internal view returns (bytes20) {
        return bytes20(eSpacePoolAddr);
    }
}

// File: contracts/1.dxCfxBridge.sol


pragma solidity ^0.8.20;

contract DxCFXBridge is Ownable, Initializable, SpaceBridge {
    IPoSOracle private posOracle;

    uint256 public aprPeriodCount;
    uint256 public poolShareRatio;
    uint256 public poolAccReward;  // accumulated pool handling fee
    uint256 public maxRedeemLenPerCall;

    function initialize() public initializer {
        aprPeriodCount = 48;
        poolShareRatio = 100_000_000;
        maxRedeemLenPerCall = 20;
    }

    function setPoSOracle(address addr) public onlyOwner {
        posOracle = IPoSOracle(addr);
    }

    function setPoolShareRatio(uint256 ratio) public onlyOwner {
        poolShareRatio = ratio;
    }

    function depositToPool() public payable onlyOwner {
        poolAccReward += msg.value;
    }

    function withdrawPoolReward(uint256 amount) public onlyOwner {
        require(amount <= poolAccReward, "DxCFXBridge: insufficient reward");
        require(amount <= address(this).balance, "DxCFXBridge: insufficient balance");
        poolAccReward -= amount;
        payable(owner()).transfer(amount);
    }

    function setMaxRedeemPerCall(uint256 _maxRedeemLenPerCall) public onlyOwner {
        maxRedeemLenPerCall = _maxRedeemLenPerCall;
    }

    function stakeAbleBalance() public view returns (uint256) {
        uint256 balance = _balance();
        if (balance <= poolAccReward) return 0;
        balance -= poolAccReward;
        uint256 needRedeem = eSpacePoolTotalRedeemed();
        if (balance <= needRedeem) return 0;
        balance -= needRedeem;
        return balance;
    }

    // average hour APR in latest aprPeriodCount period
    function poolAPR() public view returns (uint256) {
        uint256 posEpoch = posOracle.posEpochHeight();
        uint256 totalVotes;
        uint256 totalReward;

        if (posEpoch < aprPeriodCount) return 0;

        for (uint256 i = 1; i <= aprPeriodCount; i++) {
            uint256 epoch = posEpoch - i;

            uint256 poolReward = posOracle.getUserPoSReward(epoch, posPoolAddr);
            uint256 poolVotes = posOracle.getUserVotes(epoch, posPoolAddr);

            if (poolVotes == 0) continue;

            totalVotes += poolVotes;
            totalReward += poolReward;
        }

        if (totalReward == 0 || totalVotes == 0) return 0;

        uint256 apr = (totalReward * RATIO_BASE) / (totalVotes * CFX_PER_VOTE);
        return apr;
    }

    function claimReward() public onlyOwner {
        uint256 reward = poolReward();
        if (reward == 0) return;

        posPoolInterface.claimReward(reward);
        uint256 poolShare = (reward * poolShareRatio) / RATIO_BASE;
        poolAccReward += poolShare;

        eSpaceAddStake(reward - poolShare);
    }

    function stakeVotes() public onlyOwner {
        uint256 stakeAmount = _balance();

        uint256 needRedeem = eSpacePoolTotalRedeemed();
        if (stakeAmount < needRedeem) return;
        stakeAmount -= needRedeem;

        // leave pool handling fee unstake as a liquidity pool for quick redeem
        if (stakeAmount < poolAccReward) return;
        stakeAmount -= poolAccReward;

        if (stakeAmount < CFX_PER_VOTE) return;

        uint256 vote = stakeAmount / CFX_PER_VOTE;
        posPoolInterface.increaseStake{value: vote * CFX_PER_VOTE}(uint64(vote));
    }

    function unstakeVotes(uint64 votes) public onlyOwner {
        IPoSPool.UserSummary memory poolSummary = poolSummary();
        require(poolSummary.locked >= votes, "DxCFXBridge: insufficient votes");
        posPoolInterface.decreaseStake(votes);
    }

    function handleRedeem() public onlyOwner {
        // withdraw unlocked votes
        IPoSPool.UserSummary memory poolSummary = poolSummary();
        if (poolSummary.unlocked > 0) {
            posPoolInterface.withdrawStake(uint64(poolSummary.unlocked));
        }

        // use current balance handle redeem request
        uint256 redeemLen = eSpaceRedeemLen();
        if (redeemLen == 0) return;

        for (uint256 i = 0; i < redeemLen; i++) {
            bool handled = handleFirstRedeem();
            if (!handled) break;
        }

        if (poolSummary.locked == 0) return;

        uint256 totalRedeemed = eSpacePoolTotalRedeemed();
        if (totalRedeemed == 0) return;

        // use total redeemed amount minus current unlocking votes, calculate need unstake votes
        uint256 unlocking = poolSummary.votes - poolSummary.available - poolSummary.unlocked;
        if (unlocking * CFX_PER_VOTE + _balance() >= totalRedeemed) return;

        uint256 needUnstake = (totalRedeemed - unlocking * CFX_PER_VOTE) / CFX_PER_VOTE;

        if (totalRedeemed % CFX_PER_VOTE > 0) needUnstake += 1;

        if (needUnstake > poolSummary.locked) needUnstake = poolSummary.locked;

        posPoolInterface.decreaseStake(uint64(needUnstake));
    }

    function handleFirstRedeem() public onlyOwner returns (bool) {
        uint256 eSpaceFirstRedeemAmount = eSpaceFirstRedeemAmount();
        if (_balance() < eSpaceFirstRedeemAmount) return false;
        eSpaceHandleRedeem(eSpaceFirstRedeemAmount);
        return true;
    }

    function stakerNumber() public view returns (uint256) {
        return eSpacePoolStakerNumber();
    }

    /////////////// cross space call methods ///////////////

    function eSpaceAddStake(uint256 amount) public onlyOwner {
        CROSS_SPACE_CALL.callEVM(_ePoolAddrB20(), abi.encodeWithSignature("addStake(uint256)", amount));
    }

    function eSpaceHandleRedeem(uint256 amount) public onlyOwner {
        CROSS_SPACE_CALL.callEVM{value: amount}(_ePoolAddrB20(), abi.encodeWithSignature("handleRedeem()"));
    }

    function eSpaceRedeemLen() public view returns (uint256) {
        bytes memory num = CROSS_SPACE_CALL.staticCallEVM(_ePoolAddrB20(), abi.encodeWithSignature("redeemLen()"));
        return abi.decode(num, (uint256));
    }

    function eSpaceFirstRedeemAmount() public view returns (uint256) {
        bytes memory num = CROSS_SPACE_CALL.staticCallEVM(_ePoolAddrB20(), abi.encodeWithSignature("firstRedeemAmount()"));
        return abi.decode(num, (uint256));
    }

    function eSpacePoolTotalRedeemed() public view returns (uint256) {
        bytes memory num = CROSS_SPACE_CALL.staticCallEVM(_ePoolAddrB20(), abi.encodeWithSignature("totalRedeemed()"));
        return abi.decode(num, (uint256));
    }

    function eSpacePoolStakerNumber() public view returns (uint256) {
        bytes memory num = CROSS_SPACE_CALL.staticCallEVM(_ePoolAddrB20(), abi.encodeWithSignature("stakerNumber()"));
        return abi.decode(num, (uint256));
    }

    function eSpacePoolTotalStake() public view returns (uint256) {
        bytes memory num = CROSS_SPACE_CALL.staticCallEVM(_ePoolAddrB20(), abi.encodeWithSignature("totalStake()"));
        return abi.decode(num, (uint256));
    }

    function eSpacePoolTotalSupply() public view returns (uint256) {
        bytes memory num = CROSS_SPACE_CALL.staticCallEVM(_ePoolAddrB20(), abi.encodeWithSignature("totalSupply()"));
        return abi.decode(num, (uint256));
    }
}