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

// File: @openzeppelin/contracts/security/Pausable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
  /**
   * @dev Emitted when the pause is triggered by `account`.
     */
  event Paused(address account);

  /**
   * @dev Emitted when the pause is lifted by `account`.
     */
  event Unpaused(address account);

  bool private _paused;

  /**
   * @dev Initializes the contract in unpaused state.
     */
  constructor() {
    _paused = false;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
  modifier whenNotPaused() {
    _requireNotPaused();
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
  modifier whenPaused() {
    _requirePaused();
    _;
  }

  /**
   * @dev Returns true if the contract is paused, and false otherwise.
     */
  function paused() public view virtual returns (bool) {
    return _paused;
  }

  /**
   * @dev Throws if the contract is paused.
     */
  function _requireNotPaused() internal view virtual {
    require(!paused(), "Pausable: paused");
  }

  /**
   * @dev Throws if the contract is not paused.
     */
  function _requirePaused() internal view virtual {
    require(paused(), "Pausable: not paused");
  }

  /**
   * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
  function _pause() internal virtual whenNotPaused {
    _paused = true;
    emit Paused(_msgSender());
  }

  /**
   * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
  function _unpause() internal virtual whenPaused {
    _paused = false;
    emit Unpaused(_msgSender());
  }
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
  function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      uint256 c = a + b;
      if (c < a) return (false, 0);
      return (true, c);
    }
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
  function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      if (b > a) return (false, 0);
      return (true, a - b);
    }
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
  function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
      if (a == 0) return (true, 0);
      uint256 c = a * b;
      if (c / a != b) return (false, 0);
      return (true, c);
    }
  }

  /**
   * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
  function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      if (b == 0) return (false, 0);
      return (true, a / b);
    }
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
  function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
    unchecked {
      if (b == 0) return (false, 0);
      return (true, a % b);
    }
  }

  /**
   * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    return a + b;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return a - b;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    return a * b;
  }

  /**
   * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return a / b;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return a % b;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    unchecked {
      require(b <= a, errorMessage);
      return a - b;
    }
  }

  /**
   * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    unchecked {
      require(b > 0, errorMessage);
      return a / b;
    }
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    unchecked {
      require(b > 0, errorMessage);
      return a % b;
    }
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

// File: @confluxfans/contracts/InternalContracts/Staking.sol


pragma solidity >=0.4.15;

interface Staking {
  /*** Query Functions ***/
  /**
   * @dev get user's staking balance
     * @param user The address of specific user
     */
  function getStakingBalance(address user) external view returns (uint256);

  /**
   * @dev get user's locked staking balance at given blockNumber
     * @param user The address of specific user
     * @param blockNumber The blockNumber as index.
     */
  // ------------------------------------------------------------------------
  // Note: if the blockNumber is less than the current block number, function
  // will return current locked staking balance.
  // ------------------------------------------------------------------------
  function getLockedStakingBalance(address user, uint256 blockNumber) external view returns (uint256);

  /**
   * @dev get user's vote power staking balance at given blockNumber
     * @param user The address of specific user
     * @param blockNumber The blockNumber as index.
     */
  // ------------------------------------------------------------------------
  // Note: if the blockNumber is less than the current block number, function
  // will return current vote power.
  // ------------------------------------------------------------------------
  function getVotePower(address user, uint256 blockNumber) external view returns (uint256);

  function deposit(uint256 amount) external;

  function withdraw(uint256 amount) external;

  function voteLock(uint256 amount, uint256 unlockBlockNumber) external;
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

// File: contracts/PoolContext.sol


pragma solidity ^0.8.20;



abstract contract PoolContext {
  Staking private constant STAKING = Staking(0x0888000000000000000000000000000000000002);
  PoSRegister private constant POS_REGISTER = PoSRegister(0x0888000000000000000000000000000000000005);

  function _selfBalance() internal view virtual returns (uint256) {
    return address(this).balance;
  }

  function _blockNumber() internal view virtual returns (uint256) {
    return block.number;
  }

  function _stakingDeposit(uint256 _amount) internal virtual {
    STAKING.deposit(_amount);
  }

  function _stakingWithdraw(uint256 _amount) internal virtual {
    STAKING.withdraw(_amount);
  }

  function _stakingBalance() internal view returns (uint256) {
    return STAKING.getStakingBalance(address(this));
  }

  function _stakingLockedStakingBalance(uint256 blockNumber) internal view returns (uint256) {
    return STAKING.getLockedStakingBalance(address(this), blockNumber);
  }

  function _stakingVotePower(uint256 blockNumber) internal view returns (uint256) {
    return STAKING.getVotePower(address(this), blockNumber);
  }

  function _stakingVoteLock(uint256 amount, uint256 unlockBlockNumber) internal {
    STAKING.voteLock(amount, unlockBlockNumber);
  }

  function _posRegisterRegister(
    bytes32 indentifier,
    uint64 votePower,
    bytes calldata blsPubKey,
    bytes calldata vrfPubKey,
    bytes[2] calldata blsPubKeyProof
  ) internal virtual {
    POS_REGISTER.register(indentifier, votePower, blsPubKey, vrfPubKey, blsPubKeyProof);
  }

  function _posRegisterIncreaseStake(uint64 votePower) internal virtual {
    POS_REGISTER.increaseStake(votePower);
  }

  function _posRegisterRetire(uint64 votePower) internal virtual {
    POS_REGISTER.retire(votePower);
  }

  function _posAddressToIdentifier(address _addr) internal view returns (bytes32) {
    return POS_REGISTER.addressToIdentifier(_addr);
  }
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
// File: contracts/utils/PoolAPY.sol


pragma solidity ^0.8.20;

library PoolAPY {
  struct ApyNode {
    uint256 startBlock;
    uint256 endBlock;
    uint256 reward;
    uint256 available;
  }

  struct ApyQueue {
    uint256 start;
    uint256 end;
    mapping(uint256 => ApyNode) items;
  }

  function enqueue(ApyQueue storage queue, ApyNode memory item) internal {
    queue.items[queue.end++] = item;
  }

  function dequeue(ApyQueue storage queue) internal returns (ApyNode memory) {
    ApyNode memory item = queue.items[queue.start];
    delete queue.items[queue.start++];
    return item;
  }

  function clearOutdatedNode(ApyQueue storage queue, uint256 outdatedBlock) internal {
    uint256 start = queue.start;
    uint256 end = queue.end;
    for (uint256 i = start; i < end; i++) {
      if (queue.items[i].endBlock > outdatedBlock) {
        break;
      }
      dequeue(queue);
    }
  }

  function enqueueAndClearOutdated(ApyQueue storage queue, ApyNode memory item, uint256 outdatedBlock) internal {
    enqueue(queue, item);
    clearOutdatedNode(queue, outdatedBlock);
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

// File: contracts/PoSPool.sol

pragma solidity ^0.8.20;

///
///  @title PoSPool
///  @dev This is Conflux PoS pool contract
///  @notice Users can use this contract to participate Conflux PoS without running a PoS node.
///
contract PoSPool is PoolContext, Initializable, Ownable, Pausable {
  using SafeMath for uint256;
  using EnumerableSet for EnumerableSet.AddressSet;
  using VotePowerQueue for VotePowerQueue.InOutQueue;
  using PoolAPY for PoolAPY.ApyQueue;

  uint256 private RATIO_BASE = 10000;
  uint256 private CFX_COUNT_OF_ONE_VOTE = 1000;
  uint256 private CFX_VALUE_OF_ONE_VOTE = 1000 ether;
  uint256 private ONE_DAY_BLOCK_COUNT = 2 * 3600 * 24;
  uint256 private ONE_YEAR_BLOCK_COUNT = ONE_DAY_BLOCK_COUNT * 365;

  // ======================== Pool config =========================

  string public poolName;
  // wheter this poolContract registed in PoS
  bool public _poolRegistered;
  // ratio shared by user: 1-10000
  uint256 public poolUserShareRatio = 9000;
  // lock period: 13 days + half hour
  uint256 public _poolLockPeriod = ONE_DAY_BLOCK_COUNT * 13 + 3600;

  // ======================== Struct definitions =========================

  struct PoolSummary {
    uint256 available;
    uint256 reward; // PoS pool reward share
    uint256 totalReward; // total reward of whole pools
  }

  /// @title UserSummary
  /// @custom:field votes User's total votes
  /// @custom:field available User's avaliable votes
  /// @custom:field locked
  /// @custom:field unlocked
  /// @custom:field claimedReward
  /// @custom:field currentReward
  struct UserSummary {
    uint256 votes;  // Total votes in PoS system, including locking, locked, unlocking, unlocked
    uint256 available; // locking + locked
    uint256 locked;
    uint256 unlocked;
    uint256 claimedReward;
    uint256 currentReward;
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

  // ======================== Contract states =========================

  // global pool accumulative reward for each cfx
  uint256 public accRewardPerCfx;

  PoolSummary private _poolSummary;
  mapping(address => UserSummary) private _userSummaries;
  mapping(address => VotePowerQueue.InOutQueue) private _userInqueues;
  mapping(address => VotePowerQueue.InOutQueue) private _userOutqueues;

  PoolShot internal lastPoolShot;
  mapping(address => UserShot) internal lastUserShots;

  EnumerableSet.AddressSet private _stakers;
  // used to calculate latest seven days APY
  PoolAPY.ApyQueue private _apyNodes;

  // Free fee whitelist
  EnumerableSet.AddressSet private _feeFreeWhiteList;

  // unlock period: 1 days + half hour
  uint256 public _poolUnlockPeriod = ONE_DAY_BLOCK_COUNT + 3600;

  string public constant VERSION = "1.3.0";

  ParamsControl public paramsControl = ParamsControl(0x0888000000000000000000000000000000000007);

  address public votingEscrow;

  // ======================== Modifiers =========================
  modifier onlyRegistered() {
    require(_poolRegistered, "Pool is not registered");
    _;
  }

  modifier onlyVotingEscrow() {
    require(msg.sender == votingEscrow, "Only votingEscrow can call this function");
    _;
  }

  // ======================== Helpers =========================

  function _userShareRatio(address user) public view returns (uint256) {
    if (_feeFreeWhiteList.contains(user)) return RATIO_BASE;
    return poolUserShareRatio;
  }

  function _calUserShare(uint256 reward, address depositor) private view returns (uint256) {
    return reward.mul(_userShareRatio(depositor)).div(RATIO_BASE);
  }

  // used to update lastPoolShot after _poolSummary.available changed
  function _updatePoolShot() private {
    lastPoolShot.available = _poolSummary.available;
    lastPoolShot.balance = _selfBalance();
    lastPoolShot.blockNumber = _blockNumber();
  }

  // used to update lastUserShot after userSummary.available and accRewardPerCfx changed
  function _updateUserShot(address _user) private {
    lastUserShots[_user].available = _userSummaries[_user].available;
    lastUserShots[_user].accRewardPerCfx = accRewardPerCfx;
    lastUserShots[_user].blockNumber = _blockNumber();
  }

  // used to update accRewardPerCfx after _poolSummary.available changed or user claimed reward
  // depend on: lastPoolShot.available and lastPoolShot.balance
  function _updateAccRewardPerCfx() private {
    uint256 reward = _selfBalance() - lastPoolShot.balance;
    if (reward == 0 || lastPoolShot.available == 0) return;

    // update global accRewardPerCfx
    uint256 cfxCount = lastPoolShot.available.mul(CFX_COUNT_OF_ONE_VOTE);
    accRewardPerCfx = accRewardPerCfx.add(reward.div(cfxCount));

    // update pool reward info
    _poolSummary.totalReward = _poolSummary.totalReward.add(reward);
  }

  // depend on: accRewardPerCfx and lastUserShot
  function _updateUserReward(address _user) private {
    UserShot memory uShot = lastUserShots[_user];
    if (uShot.available == 0) return;
    uint256 latestReward = accRewardPerCfx.sub(uShot.accRewardPerCfx).mul(uShot.available.mul(CFX_COUNT_OF_ONE_VOTE));
    uint256 _userReward = _calUserShare(latestReward, _user);
    _userSummaries[_user].currentReward = _userSummaries[_user].currentReward.add(_userReward);
    _poolSummary.reward = _poolSummary.reward.add(latestReward.sub(_userReward));
  }

  // depend on: lastPoolShot
  function _updateAPY() private {
    if (_blockNumber() == lastPoolShot.blockNumber)  return;
    uint256 reward = _selfBalance() - lastPoolShot.balance;
    PoolAPY.ApyNode memory node = PoolAPY.ApyNode({
      startBlock: lastPoolShot.blockNumber,
      endBlock: _blockNumber(),
      reward: reward,
      available: lastPoolShot.available
    });

    uint256 outdatedBlock = 0;
    if (_blockNumber() > ONE_DAY_BLOCK_COUNT.mul(7)) {
      outdatedBlock = _blockNumber().sub(ONE_DAY_BLOCK_COUNT.mul(7));
    }
    _apyNodes.enqueueAndClearOutdated(node, outdatedBlock);
  }

  // ======================== Events =========================

  event IncreaseStake(address indexed user, uint256 votePower);

  event DecreaseStake(address indexed user, uint256 votePower);

  event WithdrawStake(address indexed user, uint256 votePower);

  event ClaimReward(address indexed user, uint256 amount);

  event RatioUpdated(uint256 ratio);

  // ======================== Init methods =========================
  constructor() Ownable(msg.sender) {}

  // call this method when deploy the 1967 proxy contract
  function initialize() public initializer {
    RATIO_BASE = 10000;
    CFX_COUNT_OF_ONE_VOTE = 1000;
    CFX_VALUE_OF_ONE_VOTE = 1000 ether;
    ONE_DAY_BLOCK_COUNT = 2 * 3600 * 24;
    ONE_YEAR_BLOCK_COUNT = ONE_DAY_BLOCK_COUNT * 365;

    _poolLockPeriod = ONE_DAY_BLOCK_COUNT * 13 + 3600;
    _poolUnlockPeriod = ONE_DAY_BLOCK_COUNT * 1 + 3600;

    poolUserShareRatio = 9000;
    paramsControl = ParamsControl(0x0888000000000000000000000000000000000007);
  }

  ///
  /// @notice Register the pool contract in PoS internal contract
  /// @dev Only admin can do this
  /// @param identifier The identifier of PoS node
  /// @param votePower The vote power when register
  /// @param blsPubKey The bls public key of PoS node
  /// @param vrfPubKey The vrf public key of PoS node
  /// @param blsPubKeyProof The bls public key proof of PoS node
  function register(
    bytes32 identifier,
    uint64 votePower,
    bytes calldata blsPubKey,
    bytes calldata vrfPubKey,
    bytes[2] calldata blsPubKeyProof
  ) public virtual payable onlyOwner {
    require(!_poolRegistered, "pool is already registered");
    require(votePower == 1, "votePower should be 1");
    require(msg.value == votePower * CFX_VALUE_OF_ONE_VOTE, "msg.value should be 1000 CFX");
    _stakingDeposit(msg.value);
    _posRegisterRegister(identifier, votePower, blsPubKey, vrfPubKey, blsPubKeyProof);
    _poolRegistered = true;

    // update user info
    _userSummaries[msg.sender].votes += votePower;
    _userSummaries[msg.sender].available += votePower;
    _userSummaries[msg.sender].locked += votePower;  // directly add to admin locked votes

    _updateUserShot(msg.sender);

    _stakers.add(msg.sender);

    // update pool info
    _poolSummary.available += votePower;
    _updatePoolShot();
  }

  // ======================== Contract methods =========================

  ///
  /// @notice Increase PoS vote power
  /// @param votePower The number of vote power to increase
  ///
  function increaseStake(uint64 votePower) public virtual payable onlyRegistered whenNotPaused {
    require(votePower > 0, "Minimal votePower is 1");
    require(msg.value == votePower * CFX_VALUE_OF_ONE_VOTE, "msg.value should be votePower * 1000 CFX");

    _stakingDeposit(msg.value);

    _posRegisterIncreaseStake(votePower);
    emit IncreaseStake(msg.sender, votePower);

    _updateAccRewardPerCfx();
    _updateAPY();

    // update user reward
    _updateUserReward(msg.sender);
    // put stake info in queue
    _userInqueues[msg.sender].enqueue(VotePowerQueue.QueueNode(votePower, _blockNumber() + _poolLockPeriod));
    _userSummaries[msg.sender].locked += _userInqueues[msg.sender].collectEndedVotes();
    _userSummaries[msg.sender].votes += votePower;
    _userSummaries[msg.sender].available += votePower;

    _updateUserShot(msg.sender);

    _stakers.add(msg.sender);

    _poolSummary.available += votePower;
    _updatePoolShot();
  }

  ///
  /// @notice Decrease PoS vote power
  /// @param votePower The number of vote power to decrease
  ///
  function decreaseStake(uint64 votePower) public virtual onlyRegistered {
    _userSummaries[msg.sender].locked += _userInqueues[msg.sender].collectEndedVotes();
    require(_userSummaries[msg.sender].locked >= votePower, "Locked is not enough");

    // if user has locked cfx for vote power, the rest amount should bigger than that
    IVotingEscrow.LockInfo memory lockInfo = IVotingEscrow(votingEscrow).userLockInfo(msg.sender);
    require((_userSummaries[msg.sender].available - votePower) * CFX_VALUE_OF_ONE_VOTE >= lockInfo.amount, "Locked is not enough");

    _posRegisterRetire(votePower);
    emit DecreaseStake(msg.sender, votePower);

    _updateAccRewardPerCfx();
    _updateAPY();

    // update user reward
    _updateUserReward(msg.sender);

    _userOutqueues[msg.sender].enqueue(VotePowerQueue.QueueNode(votePower, _blockNumber() + _poolUnlockPeriod));
    _userSummaries[msg.sender].unlocked += _userOutqueues[msg.sender].collectEndedVotes();
    _userSummaries[msg.sender].available -= votePower;
    _userSummaries[msg.sender].locked -= votePower;
    _updateUserShot(msg.sender);

    _poolSummary.available -= votePower;
    _updatePoolShot();
  }

  ///
  /// @notice Withdraw PoS vote power
  /// @param votePower The number of vote power to withdraw
  ///
  function withdrawStake(uint64 votePower) public onlyRegistered {
    _userSummaries[msg.sender].unlocked += _userOutqueues[msg.sender].collectEndedVotes();
    require(_userSummaries[msg.sender].unlocked >= votePower, "Unlocked is not enough");
    _stakingWithdraw(votePower * CFX_VALUE_OF_ONE_VOTE);

    _userSummaries[msg.sender].unlocked -= votePower;
    _userSummaries[msg.sender].votes -= votePower;

    address payable receiver = payable(msg.sender);
    receiver.transfer(votePower * CFX_VALUE_OF_ONE_VOTE);
    emit WithdrawStake(msg.sender, votePower);

    if (_userSummaries[msg.sender].votes == 0) {
      _stakers.remove(msg.sender);
    }
  }

  ///
  /// @notice User's reward from participate PoS
  /// @param depositor The address of depositor to query
  /// @return CFX reward in Drip
  ///
  function getUserReward(address depositor) public view returns(uint256) {
    uint256 currentReward = _userSummaries[depositor].currentReward;

    uint256 latestAccRewardPerCfx = accRewardPerCfx;
    uint256 latestPoolReward = _selfBalance() - lastPoolShot.balance;
    UserShot memory uShot = lastUserShots[depositor];
    if (latestPoolReward > 0) {
        uint256 _deltaAcc = latestPoolReward.div(lastPoolShot.available.mul(CFX_COUNT_OF_ONE_VOTE));
        latestAccRewardPerCfx = latestAccRewardPerCfx.add(_deltaAcc);
    }

    if (uShot.available > 0) {
      uint256 latestReward = latestAccRewardPerCfx.sub(uShot.accRewardPerCfx).mul(uShot.available.mul(CFX_COUNT_OF_ONE_VOTE));
      currentReward = currentReward.add(_calUserShare(latestReward, depositor));
    }
    return currentReward;
  }

  ///
  /// @notice User's reward from participate PoS
  /// @param depositor The address of depositor to query
  /// @return depositor totalRewards, unClaimedRewards, claimedRewards
  ///
  function getUserRewardInfo(address depositor) public view returns (uint256, uint256, uint256) {
    uint256 currentRewards = _userSummaries[depositor].currentReward;
    uint256 claimedRewards = _userSummaries[depositor].claimedReward;
    uint256 latestAccRewardPerCfx = accRewardPerCfx;
    uint256 latestPoolReward = _selfBalance() - lastPoolShot.balance;
    UserShot memory uShot = lastUserShots[depositor];
    if (latestPoolReward > 0) {
        uint256 _deltaAcc = latestPoolReward.div(lastPoolShot.available.mul(CFX_COUNT_OF_ONE_VOTE));
        latestAccRewardPerCfx = latestAccRewardPerCfx.add(_deltaAcc);
    }

    if (uShot.available > 0) {
        uint256 latestReward = latestAccRewardPerCfx.sub(uShot.accRewardPerCfx).mul(uShot.available.mul(CFX_COUNT_OF_ONE_VOTE));
        currentRewards = currentRewards.add(_calUserShare(latestReward, depositor));
    }

      uint256 totalRewards = currentRewards + claimedRewards;
      return (totalRewards, currentRewards, claimedRewards);
  }

  ///
  /// @notice Claim specific amount user reward
  /// @param amount The amount of reward to claim
  ///
  function claimReward(uint amount) public onlyRegistered {
    uint claimableReward = getUserReward(msg.sender);
    require(claimableReward >= amount, "User Reward is not enough");

    _updateAccRewardPerCfx();
    _updateAPY();

    _updateUserReward(msg.sender);

    _userSummaries[msg.sender].claimedReward = _userSummaries[msg.sender].claimedReward.add(amount);
    _userSummaries[msg.sender].currentReward = _userSummaries[msg.sender].currentReward.sub(amount);
    // update userShot's accRewardPerCfx
    _updateUserShot(msg.sender);

    // send reward to user
    address payable receiver = payable(msg.sender);
    receiver.transfer(amount);
    emit ClaimReward(msg.sender, amount);

    // update blockNumber and balance
    _updatePoolShot();
  }

  ///
  /// @notice Claim one user's all reward
  ///
  function claimAllReward() public onlyRegistered {
    uint claimableReward = getUserReward(msg.sender);
    require(claimableReward > 0, "No claimable reward");
    claimReward(claimableReward);
  }

  ///
  /// @notice Get user's pool summary
  /// @param user The address of user to query
  /// @return User's summary
  ///
  function userSummary(address user) public view returns (UserSummary memory) {
    UserSummary memory summary = _userSummaries[user];
    summary.locked += _userInqueues[user].sumEndedVotes();
    summary.unlocked += _userOutqueues[user].sumEndedVotes();
    return summary;
  }

  function poolSummary() public view returns (PoolSummary memory) {
    PoolSummary memory summary = _poolSummary;
    uint256 latestReward = _selfBalance().sub(lastPoolShot.balance);
    summary.totalReward = summary.totalReward.add(latestReward);
    return summary;
  }

  function poolAPY() public view returns (uint256) {
    if(_apyNodes.start == _apyNodes.end) return 0;

    uint256 totalReward = 0;
    uint256 totalStake = 0;
    for(uint256 i = _apyNodes.start; i < _apyNodes.end; i++) {
      PoolAPY.ApyNode memory node = _apyNodes.items[i];
      totalReward = totalReward.add(node.reward);
      totalStake = totalStake.add(node.available.mul(CFX_VALUE_OF_ONE_VOTE).mul(node.endBlock - node.startBlock));
    }

    if (_blockNumber() > lastPoolShot.blockNumber) {
      uint256 latestReward = _selfBalance().sub(lastPoolShot.balance);
      totalReward = totalReward.add(latestReward);
      totalStake = totalStake.add(lastPoolShot.available.mul(CFX_VALUE_OF_ONE_VOTE).mul(_blockNumber() - lastPoolShot.blockNumber));
    }

    return totalReward.mul(RATIO_BASE).mul(ONE_YEAR_BLOCK_COUNT).div(totalStake);
  }

  ///
  /// @notice Query pools contract address
  /// @return Pool's PoS address
  ///
  function posAddress() public view onlyRegistered returns (bytes32) {
    return _posAddressToIdentifier(address(this));
  }

  function userInQueue(address account) public view returns (VotePowerQueue.QueueNode[] memory) {
    return _userInqueues[account].queueItems();
  }

  function userOutQueue(address account) public view returns (VotePowerQueue.QueueNode[] memory) {
    return _userOutqueues[account].queueItems();
  }

  function userInQueue(address account, uint64 offset, uint64 limit) public view returns (VotePowerQueue.QueueNode[] memory) {
    return _userInqueues[account].queueItems(offset, limit);
  }

  function userOutQueue(address account, uint64 offset, uint64 limit) public view returns (VotePowerQueue.QueueNode[] memory) {
    return _userOutqueues[account].queueItems(offset, limit);
  }

  function stakerNumber() public view returns (uint) {
    return _stakers.length();
  }

  function stakerAddress(uint256 i) public view returns (address) {
    return _stakers.at(i);
  }

  function userShareRatio() public view returns (uint256) {
    return _userShareRatio(msg.sender);
  }

  function poolShot() public view returns (PoolShot memory) {
    return lastPoolShot;
  }

  function userShot(address user) public view returns (UserShot memory) {
    return lastUserShots[user];
  }

  function lockForVotePower(uint256 amount, uint256 unlockBlockNumber) public onlyVotingEscrow {
    _stakingVoteLock(amount, unlockBlockNumber);
  }

  function castVote(uint64 vote_round, ParamsControl.Vote[] calldata vote_data) public onlyVotingEscrow {
    paramsControl.castVote(vote_round, vote_data);
  }

  function userLockInfo(address user) public view returns (IVotingEscrow.LockInfo memory) {
    return IVotingEscrow(votingEscrow).userLockInfo(user);
  }

  function userVotePower(address user) external view returns (uint256) {
    return IVotingEscrow(votingEscrow).userVotePower(user);
  }

  // ======================== admin methods =====================

  ///
  /// @notice Enable admin to set the user share ratio
  /// @dev The ratio base is 10000, only admin can do this
  /// @param ratio The reward user share ratio (1-10000), default is 9000
  ///
  function setPoolUserShareRatio(uint64 ratio) public onlyOwner {
    require(ratio > 0 && ratio <= RATIO_BASE, "pool share ratio should be 1-10000");
    poolUserShareRatio = ratio;
    emit RatioUpdated(ratio);
  }

  ///
  /// @notice Enable admin to set the lock and unlock period
  /// @dev Only admin can do this
  /// @param period The lock period in block number, default is seven day's block count
  ///
  function setLockPeriod(uint64 period) public onlyOwner {
    _poolLockPeriod = period;
  }

  function setUnlockPeriod(uint64 period) public onlyOwner {
    _poolUnlockPeriod = period;
  }

  function addToFeeFreeWhiteList(address _freeAddress) public onlyOwner returns (bool) {
    return _feeFreeWhiteList.add(_freeAddress);
  }

  function removeFromFeeFreeWhiteList(address _freeAddress) public onlyOwner returns (bool) {
    return _feeFreeWhiteList.remove(_freeAddress);
  }

  ///
  /// @notice Enable admin to set the pool name
  ///
  function setPoolName(string memory name) public onlyOwner {
    poolName = name;
  }

  /// @param count Vote cfx count, unit is cfx
  function setCfxCountOfOneVote(uint256 count) public onlyOwner {
    CFX_COUNT_OF_ONE_VOTE = count;
    CFX_VALUE_OF_ONE_VOTE = count * 1 ether;
  }

  function setVotingEscrow(address _votingEscrow) public onlyOwner {
    votingEscrow = _votingEscrow;
  }

  function setParamsControl() public onlyOwner {
    paramsControl = ParamsControl(0x0888000000000000000000000000000000000007);
  }

  function withdrawPoolProfit(uint256 amount) public onlyOwner {
    require(_poolSummary.reward > amount, "Pool reward must be greater than withdraw amount");
    require(_selfBalance() > amount, "Pool balance must be greater than withdraw amount");
    _poolSummary.reward = _poolSummary.reward.sub(amount);
    address payable receiver = payable(msg.sender);
    receiver.transfer(amount);
    _updatePoolShot();
  }

  function retireUserStake(address depositor, uint64 endBlockNumber) public onlyOwner {
    uint256 votePower = _userSummaries[depositor].available;
    if (votePower == 0) return;

    _updateAccRewardPerCfx();

    _updateUserReward(depositor);

    _userSummaries[depositor].available = 0;
    _userSummaries[depositor].locked = 0;
    // clear user inqueue
    _userInqueues[depositor].clear();
    _userOutqueues[depositor].enqueue(VotePowerQueue.QueueNode(votePower, endBlockNumber));
    _updateUserShot(depositor);

    _poolSummary.available -= votePower;
    _updatePoolShot();
  }

  function restakePosVote(uint64 votes) public onlyOwner {
    _posRegisterIncreaseStake(votes);
  }

  function restakeUserStake(address depositor) public onlyOwner {
    _userSummaries[depositor].unlocked += _userOutqueues[depositor].collectEndedVotes();
    uint256 votePower = _userSummaries[depositor].unlocked;
    require(votePower > 0, "minimal votePower is 1");

    _posRegisterIncreaseStake(uint64(votePower));

    // put stake info in queue
    _userInqueues[depositor].enqueue(VotePowerQueue.QueueNode(votePower, _blockNumber() + _poolLockPeriod));
    _userSummaries[depositor].available += votePower;
    _userSummaries[depositor].unlocked = 0;
    _updateUserShot(depositor);

    _poolSummary.available += votePower;
    _updatePoolShot();
  }

  // pause the contract
  function pauseContract() external onlyOwner {
    _pause();
  }

  // unpause the contract
  function unpauseContract() external onlyOwner {
    _unpause();
  }
}