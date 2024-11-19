
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
     * @dev Throws if called by any account standard than the owner.
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

// File: @confluxfans/contracts/InternalContracts/ConfluxContext.sol


pragma solidity >=0.4.15;

interface ConfluxContext {
    /*** Query Functions ***/
    /**
     * @dev get the current epoch number
     * @return the current epoch number
     */
    function epochNumber() external view returns (uint256);

    /**
     * @dev get the height of the referred PoS block in the last epoch
`    * @return the current PoS block height
     */
    function posHeight() external view returns (uint256);

    /**
     * @dev get the epoch number of the finalized pivot block.
     * @return the finalized epoch number
     */
    function finalizedEpochNumber() external view returns (uint256);
}

// File: @confluxfans/contracts/InternalContracts/PoSRegister.sol


pragma solidity >=0.5.0;

interface PoSRegister {
    /**
     * @dev Register PoS account
     * @param identifier - PoS account address to register
     * @param votePower - votes count
     * @param blsPubKey - BLS public key
     * @param vrfPubKey - VRF public key
     * @param blsPubKeyProof - BLS public key's proof of legality, used to against some attack, generated by conflux-rust fullnode
     */
    function register(
        bytes32 identifier,
        uint64 votePower,
        bytes calldata blsPubKey,
        bytes calldata vrfPubKey,
        bytes[2] calldata blsPubKeyProof
    ) external;

    /**
     * @dev Increase specified number votes for msg.sender
     * @param votePower - count of votes to increase
     */
    function increaseStake(uint64 votePower) external;

    /**
     * @dev Retire specified number votes for msg.sender
     * @param votePower - count of votes to retire
     */
    function retire(uint64 votePower) external;

    /**
     * @dev Query PoS account's lock info. Include "totalStakedVotes" and "totalUnlockedVotes"
     * @param identifier - PoS address
     */
    function getVotes(bytes32 identifier) external view returns (uint256, uint256);

    /**
     * @dev Query the PoW address binding with specified PoS address
     * @param identifier - PoS address
     */
    function identifierToAddress(bytes32 identifier) external view returns (address);

    /**
     * @dev Query the PoS address binding with specified PoW address
     * @param addr - PoW address
     */
    function addressToIdentifier(address addr) external view returns (bytes32);

    /**
     * @dev Emitted when register method executed successfully
     */
    event Register(bytes32 indexed identifier, bytes blsPubKey, bytes vrfPubKey);

    /**
     * @dev Emitted when increaseStake method executed successfully
     */
    event IncreaseStake(bytes32 indexed identifier, uint64 votePower);

    /**
     * @dev Emitted when retire method executed successfully
     */
    event Retire(bytes32 indexed identifier, uint64 votePower);
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

// File: contracts/1.dxPosOracle.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract PoSOracle is Ownable, IPoSOracle {
    ConfluxContext constant CFX_CONTEXT = ConfluxContext(0x0888000000000000000000000000000000000004);
    PoSRegister constant POS_REGISTER = PoSRegister(0x0888000000000000000000000000000000000005);

    uint256 public posEpochHeight; // PoS epoch height
    mapping(bytes32 => IPoSOracle.PoSAccountInfo) private _posAccountCurrentInfos; // posAccount => PoSAccountInfo
    mapping(uint256 => mapping(address => IPoSOracle.RewardInfo)) private _rewardInfos; // epochNumber => (powAccount => RewardInfo)
    mapping(uint256 => mapping(address => uint256)) private _userVoteInfos; // epochNumber => (powAccount => availableVotes)

    constructor() Ownable(msg.sender) {}
    /**
     * @dev update account current, user vote info, pos epoch height
     * @param account pos address
     * @param epochNumber pos epoch number
     * @param blockNumber  pos block number
     * @param availableVotes available votes
     * @param unlocked unlocked votes
     * @param locked locked votes
     * @param forfeited pos node forfeited votes
     * @param forceRetired is pos node force retired
     * @param inQueue node in queue info
     * @param outQueue node out queue info
     */
    function updatePoSAccountInfo(
        bytes32 account,
        uint256 epochNumber,
        uint256 blockNumber,
        uint256 availableVotes,
        uint256 unlocked,
        uint256 locked,
        uint256 forfeited,
        bool forceRetired,
        IPoSOracle.VoteInfo[] memory inQueue,
        IPoSOracle.VoteInfo[] memory outQueue
    ) public onlyOwner {
        _posAccountCurrentInfos[account].availableVotes = availableVotes;
        _posAccountCurrentInfos[account].unlocked = unlocked;
        _posAccountCurrentInfos[account].locked = locked;
        _posAccountCurrentInfos[account].forfeited = forfeited;
        _posAccountCurrentInfos[account].forceRetired = forceRetired;
        _posAccountCurrentInfos[account].blockNumber = blockNumber;
        _posAccountCurrentInfos[account].epochNumber = epochNumber;

        delete _posAccountCurrentInfos[account].inQueue;
        for (uint256 i = 0; i < inQueue.length; i++) {
            _posAccountCurrentInfos[account].inQueue.push(inQueue[i]);
        }
        delete _posAccountCurrentInfos[account].outQueue;
        for (uint256 i = 0; i < outQueue.length; i++) {
            _posAccountCurrentInfos[account].outQueue.push(outQueue[i]);
        }

        // update userVoteInfos
        address _addr = POS_REGISTER.identifierToAddress(account);
        _userVoteInfos[epochNumber][_addr] = availableVotes;

        // update posEpochHeight
        updatePoSEpochHeight(epochNumber);
    }

    function updateUserVotes(uint256 epoch, address powAddr, uint256 availableVotes) public onlyOwner {
        _userVoteInfos[epoch][powAddr] = availableVotes;
        updatePoSEpochHeight(epoch);
    }

    function updatePoSRewardInfo(uint256 epoch, address powAddress,  bytes32 posAddress, uint256 reward) public onlyOwner
    {
        _rewardInfos[epoch][powAddress].posAddress = posAddress;
        _rewardInfos[epoch][powAddress].powAddress = powAddress;
        _rewardInfos[epoch][powAddress].reward = reward;
    }

    function updatePoSEpochHeight(uint256 latestPoSEpochHeight) public onlyOwner {
        posEpochHeight = latestPoSEpochHeight;
    }

    function getPoSAccountInfo(bytes32 posAddr) public view returns (IPoSOracle.PoSAccountInfo memory) {
        return _posAccountCurrentInfos[posAddr];
    }

    /**
     * @dev get latest PoS account info by pow address
     */
    function getPoSAccountInfo(address powAddr) public view returns (IPoSOracle.PoSAccountInfo memory) {
        bytes32 addr = POS_REGISTER.addressToIdentifier(powAddr);
        return _posAccountCurrentInfos[addr];
    }

    /**
     * @dev get user PoS reward info at specific epoch by pow address
     */
    function getUserPoSReward(uint256 epoch, address powAddr) public view returns (uint256) {
        return _rewardInfos[epoch][powAddr].reward;
    }

    /**
     * @dev get user PoS available votes at specific epoch by pow address
     */
    function getUserVotes(uint256 epoch, address powAddr) public view returns (uint256) {
        return _userVoteInfos[epoch][powAddr];
    }

    /**
     * @dev get pow epoch number
    */
    function powEpochNumber() public view returns (uint256) {
        return CFX_CONTEXT.epochNumber();
    }

    /**
     * @dev get pos block number/height
     */
    function posBlockHeight() public view returns (uint256) {
        return CFX_CONTEXT.posHeight();
    }
}
