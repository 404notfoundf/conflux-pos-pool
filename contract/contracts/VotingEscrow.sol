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

// File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

pragma solidity ^0.8.20;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position is the index of the value in the `values` array plus 1.
        // Position 0 is used to mean a value is not in the set.
        mapping(bytes32 value => uint256) _positions;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._positions[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We cache the value's position to prevent multiple reads from the same storage slot
        uint256 position = set._positions[value];

        if (position != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 valueIndex = position - 1;
            uint256 lastIndex = set._values.length - 1;

            if (valueIndex != lastIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the lastValue to the index where the value to delete is
                set._values[valueIndex] = lastValue;
                // Update the tracked position of the lastValue (that was just moved)
                set._positions[lastValue] = position;
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the tracked position for the deleted slot
            delete set._positions[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._positions[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
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
    function userInterest(address _address) external view returns (uint256);
    function claimInterest(uint256 amount) external;
    function claimAllInterest() external;
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
// File: contracts/1.dxVotingEscrow.sol

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface IEspaceBridge {
    function lastUnlockBlock() external view returns (uint256);
    function globalLockAmount(uint256) external view returns (uint256);
    function poolVoteInfo(uint64, uint16, uint256) external view returns (uint256);
}

contract VotingEscrow is Ownable, Initializable, IVotingEscrow {
    // Add the library methods
    using EnumerableSet for EnumerableSet.AddressSet;

    ParamsControl private constant paramsControl = ParamsControl(0x0888000000000000000000000000000000000007);
    uint256 private constant ONE_DAY_BLOCK_NUMBER = 2 * 3600 * 24;
    uint256 public constant QUARTER_BLOCK_NUMBER = ONE_DAY_BLOCK_NUMBER * 365 / 4; // 3 months
    uint256 private constant CFX_VALUE_OF_ONE_VOTE = 1000 ether;
    uint16 private constant TOTAL_TOPIC = 4;

    IPoSPool public posPool;

    mapping(uint256 => uint256) public globalLockAmount; // unlock block => amount (user total lock amount)
    mapping(address => LockInfo) private _userLockInfo;
    uint256 public lastUnlockBlock;

    // round => user => topic => votes
    mapping(uint64 => mapping(address => mapping(uint16 => uint256[3]))) private userVoteInfo;
    // round => topic => votes
    mapping(uint64 => mapping(uint16 => uint256[3])) public poolVoteInfo;

    struct VoteMeta {
        uint256 blockNumber;
        uint256 availablePower;
    }

    // round => user => topic => meta
    mapping(uint64 => mapping(address => mapping(uint16 => VoteMeta))) private userVoteMeta;
    // round => topic => users
    mapping(uint64 => mapping(uint16 => EnumerableSet.AddressSet)) private topicSpecialVoters; // voters who's vote power maybe will change at round end block

    address public eSpaceBridge;

    modifier onlyeSpaceBridge() {
        require(msg.sender == eSpaceBridge, "Only eSpaceBridge can call this function");
        _;
    }

    constructor() Ownable(msg.sender) {}

    function initialize() public initializer {
    }

    // admin functions
    function setPosPool(address _posPool) public onlyOwner {
        posPool = IPoSPool(_posPool);
    }

    // admin functions
    function setESpaceBridge(address addr) public onlyOwner {
        eSpaceBridge = addr;
    }

    // available staked amount
    function userStakeAmount(address user) public override view returns (uint256) {
        return posPool.userSummary(user).available * CFX_VALUE_OF_ONE_VOTE;
    }

    function createLock(uint256 amount, uint256 unlockBlock) public override {
        unlockBlock = _adjustBlockNumber(unlockBlock);
        require(unlockBlock > block.number, "invalid unlock block");
        require(unlockBlock - block.number > QUARTER_BLOCK_NUMBER, "Governance: unlock block too close");
        require(_userLockInfo[msg.sender].amount == 0 || _userLockInfo[msg.sender].unlockBlock < block.number, "Governance: already locked");
        require(amount <= userStakeAmount(msg.sender), "Governance: insufficient balance");

        _userLockInfo[msg.sender] = LockInfo(amount, unlockBlock);
        globalLockAmount[unlockBlock] += amount;

        _updateLastUnlockBlock(unlockBlock);
        _lockStake();
    }

    function increaseLock(uint256 amount) public override {
        require(_userLockInfo[msg.sender].amount > 0, "Governance: not locked");
        require(_userLockInfo[msg.sender].unlockBlock > block.number, "Governance: already unlocked");
        require(_userLockInfo[msg.sender].amount + amount <= userStakeAmount(msg.sender), "Governance: insufficient balance");

        uint256 unlockBlock = _userLockInfo[msg.sender].unlockBlock;
        _userLockInfo[msg.sender].amount += amount;
        globalLockAmount[unlockBlock] += amount;

        _lockStake();
    }

    function extendLockTime(uint256 unlockBlock) public override {
        unlockBlock = _adjustBlockNumber(unlockBlock);
        require(_userLockInfo[msg.sender].amount > 0, "Governance: not locked");
        require(_userLockInfo[msg.sender].unlockBlock > block.number, "Governance: already unlocked");
        require(unlockBlock > _userLockInfo[msg.sender].unlockBlock, "Governance: invalid unlock block");

        uint256 oldUnlockNumber = _userLockInfo[msg.sender].unlockBlock;
        uint256 amount = _userLockInfo[msg.sender].amount;

        _userLockInfo[msg.sender].unlockBlock = unlockBlock;
        globalLockAmount[oldUnlockNumber] -= amount;
        globalLockAmount[unlockBlock] += amount;

        _updateLastUnlockBlock(unlockBlock);
        _lockStake();
    }

    function userVotePower(address user, uint256 blockNumber) public override view returns (uint256) {
        if (_userLockInfo[user].amount == 0 || _userLockInfo[user].unlockBlock < blockNumber) {
            return 0;
        }

        uint256 period = (_userLockInfo[user].unlockBlock - blockNumber) / QUARTER_BLOCK_NUMBER;

        // full vote power if period >= 4
        if (period > 4) {
            period = 4;
        }

        if (period == 3) {  // no 0.75
            period = 2;
        }

        return _userLockInfo[user].amount * period / 4;
    }

    function userVotePower(address user) public override view returns (uint256) {
        return userVotePower(user, block.number);
    }

    function userLockInfo(address user) public override view returns (LockInfo memory) {
        return userLockInfo(user, block.number);
    }

    function userLockInfo(address user, uint256 blockNumber) public override view returns (LockInfo memory) {
        LockInfo memory info = _userLockInfo[user];
        if (info.unlockBlock < blockNumber) {
            info.amount = 0;
            info.unlockBlock = 0;
        }
        return info;
    }

    function castVote(uint64 vote_round, uint16 topic_index, uint256[3] memory votes) public override {
        require(_onlyOneVote(votes), "Only one vote is allowed");
        require(vote_round == paramsControl.currentRound(), "Governance: invalid vote round");
        uint256 totalVotes = _sumVote(votes);
        require(userVotePower(msg.sender) >= totalVotes, "Governance: insufficient vote power");

        // if one user's vote power maybe will change, add it to topicSpecialVoters
        if (userVotePower(msg.sender, _currentRoundEndBlock()) < totalVotes) {
            topicSpecialVoters[vote_round][topic_index].add(msg.sender);
            userVoteMeta[vote_round][msg.sender][topic_index] = VoteMeta(block.number, totalVotes);
        }

        // update userVoteInfo and poolVoteInfo
        for (uint16 i = 0; i < votes.length; i++) {
            uint256 lastVote = userVoteInfo[vote_round][msg.sender][topic_index][i];
            if (votes[i] > lastVote) {
                uint256 delta = votes[i] - lastVote;
                poolVoteInfo[vote_round][topic_index][i] += delta;
            } else {
                uint256 delta = lastVote - votes[i];
                poolVoteInfo[vote_round][topic_index][i] -= delta;
            }
            userVoteInfo[vote_round][msg.sender][topic_index][i] = votes[i];
        }

        // update users who's vote power have changed
        if (topicSpecialVoters[vote_round][topic_index].length() > 0) {
            for(uint256 i = 0; i < topicSpecialVoters[vote_round][topic_index].length(); i ++) {
                address addr = topicSpecialVoters[vote_round][topic_index].at(i);
                if (addr == msg.sender) {
                    continue;
                }
                // uint256 lastBlockNumber = userVoteMeta[vote_round][addr][topic_index].blockNumber;
                uint256 lastPower = userVoteMeta[vote_round][addr][topic_index].availablePower;
                uint256 currentPower = userVotePower(addr);
                if (lastPower > currentPower) {
                    uint256 delta = lastPower - currentPower;
                    uint256 index = _findVoteIndex(userVoteInfo[vote_round][addr][topic_index]);
                    userVoteInfo[vote_round][addr][topic_index][index] -= delta;
                    poolVoteInfo[vote_round][topic_index][index] -= delta;
                    if (currentPower == userVotePower(addr, _currentRoundEndBlock())) {
                        topicSpecialVoters[vote_round][topic_index].remove(msg.sender);
                        delete userVoteMeta[vote_round][addr][topic_index];
                    } else {
                        userVoteMeta[vote_round][addr][topic_index] = VoteMeta(block.number, currentPower);
                    }
                }
            }
        }

        // do the vote cast
        _castVote(vote_round, topic_index);
    }

    function _castVote(uint64 vote_round, uint16 topic_index) internal {
        ParamsControl.Vote[] memory structVotes = new ParamsControl.Vote[](1);
        structVotes[0] = ParamsControl.Vote(topic_index, poolVoteInfo[vote_round][topic_index]);

        // sum votes from eSpaceBridge
        if (eSpaceBridge != address(0)) {

            for (uint16 i = 0; i < 3; i++) { // votes.length is 3
                uint256 votes = IEspaceBridge(eSpaceBridge).poolVoteInfo(vote_round, topic_index, uint256(i));
                structVotes[0].votes[i] += votes;
            }
        }

        posPool.castVote(vote_round, structVotes);
        emit CastVote(msg.sender, vote_round, topic_index, structVotes[0].votes);
    }

    function readVote(address addr, uint16 topicIndex) public override view returns (ParamsControl.Vote memory) {
        ParamsControl.Vote memory vote = ParamsControl.Vote(topicIndex, userVoteInfo[paramsControl.currentRound()][addr][topicIndex]);
        return vote;
    }

    function _updateLastUnlockBlock(uint256 lastBlock) internal {
        if (lastBlock > lastUnlockBlock) {
            lastUnlockBlock = lastBlock;
        }
    }

    function _getLastUnlockBlock() internal view returns (uint256) {
        if (eSpaceBridge != address(0)) {
            uint256 espaceUnlock = IEspaceBridge(eSpaceBridge).lastUnlockBlock();
            if (espaceUnlock > lastUnlockBlock) {
                return espaceUnlock;
            }
        }
        return lastUnlockBlock;
    }

    function _lockStake() internal {
        uint256 accAmount = 0;
        uint256 blockNumber = _getLastUnlockBlock();

        while (blockNumber >= block.number) {
            accAmount += globalLockAmount[blockNumber];

            // add eSpaceBridge lock amount
            if (eSpaceBridge != address(0)) {
                accAmount += IEspaceBridge(eSpaceBridge).globalLockAmount(blockNumber);
            }

            if (accAmount == 0) {
                continue;
            }

            posPool.lockForVotePower(accAmount, blockNumber);
            emit VoteLock(accAmount, blockNumber);

            blockNumber -= QUARTER_BLOCK_NUMBER;
        }
    }

    function triggerLock() public override onlyeSpaceBridge {
        _lockStake();
    }

    function triggerVote() public override onlyeSpaceBridge {
        uint64 vote_round = paramsControl.currentRound();
        for (uint16 i = 0; i < TOTAL_TOPIC; i++) {
            _castVote(vote_round, i);
        }
    }

    function _currentRoundEndBlock() internal view returns (uint256) {
        // not sure 8888 network one round period is how long
        return _onChainDaoStartBlock() + paramsControl.currentRound() * ONE_DAY_BLOCK_NUMBER * 60;
    }

    function _onChainDaoStartBlock() internal view returns (uint256) {
        uint256 cid = _getChainID();
        if (cid == 1) {
            return 112400000;
        } else if (cid == 1029) {
            return 133800000;
        } else if (cid == 8888) {
            return 100000;  // maybe will change
        }
        return 0;
    }

    function _getChainID() internal view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    // internal functions
    function _adjustBlockNumber(uint256 blockNumber) internal pure returns (uint256) {
        uint256 adjusted = (blockNumber / QUARTER_BLOCK_NUMBER) * QUARTER_BLOCK_NUMBER;
        if (adjusted < blockNumber) { // if not divide exactly
            return adjusted + QUARTER_BLOCK_NUMBER;
        }
        return adjusted;
    }

    function _sumVote(uint256[3] memory votes) internal pure returns (uint256) {
        uint256 totalVotes = 0;
        for (uint16 i = 0; i < 3; i++) {
            totalVotes += votes[i];
        }
        return totalVotes;
    }

    function _onlyOneVote(uint256[3] memory votes) internal pure returns (bool) {
        uint256 count = 0;
        for (uint16 i = 0; i < 3; i++) {
            if (votes[i] > 0) {
                count++;
            }
        }
        return count == 1;
    }

    function _findVoteIndex(uint256[3] memory votes) internal pure returns (uint256) {
        for (uint16 i = 0; i < 3; i++) {
            if (votes[i] > 0) {
                return i;
            }
        }
        return votes.length; // no index found
    }
}