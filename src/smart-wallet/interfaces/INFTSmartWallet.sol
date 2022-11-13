// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface INFTSmartWalletEvents {
    event TransferApprovalChanged(address indexed from, address indexed to, bool status);
}

interface INFTSmartWallet is INFTSmartWalletEvents {
    /// @dev Initialization function used instead of a constructor,
    ///      since the intended creation method is cloning
    function initialize(uint256 controllerId) external;

    /// @dev Makes an arbitrary function call with value to a contract, with provided calldata
    /// @param target Address of a contract to call
    /// @param callData Data to pass with the call
    /// @notice Payable. The passed value will be forwarded to the target.
    function execute(address target, bytes memory callData) external payable returns (bytes memory);

    /// @dev Makes an arbitrary function call with value to a contract, with provided calldata and value
    /// @param target Address of a contract to call
    /// @param callData Data to pass with the call
    /// @param value ETH value to pass to the target
    /// @notice Payable. Allows the user to explicitly state the ETH value, in order to,
    ///         e.g., pay with the contract's own balance.
    function execute(address target, bytes memory callData, uint256 value) external payable returns (bytes memory);

    /// @notice Makes an arbitrary call to an address attaching value and optional calldata using raw .call{value}
    /// @param target Address of the destination
    /// @param callData Optional data to pass with the call
    /// @param value Optional ETH value to pass to the target
    function rawExecute(address target, bytes memory callData, uint256 value) external payable returns (bytes memory);

    /// @dev Returns the current owner of the wallet
    function owner() external view returns (address);
}
