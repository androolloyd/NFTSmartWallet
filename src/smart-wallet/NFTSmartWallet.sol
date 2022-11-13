// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {INFTSmartWallet} from "./interfaces/INFTSmartWallet.sol";
import {Initializable} from "./Initializable.sol";
import {Address} from "./utils/Address.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";
/// @title NFT smart wallet
/// @notice NFT smart wallet that allows the owner to
///         interact with any contracts the same way as from an EOA. The
///         main intended use is to make non-transferrable positions and assets
///         liquid and usable in strategies.
/// @notice Intended to be used with a factory and the cloning pattern.
contract NFTSmartWallet is INFTSmartWallet, Initializable {
    using Address for address;

    uint256 public controllerId;
    ERC721 public controller;
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    /// @inheritdoc INFTSmartWallet
    function initialize(uint256 _controllerId)
        external
        override
        initializer
    {
        require(_controllerId > uint256(0));
        controllerId = _controllerId;
        controller = ERC721(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == controller.ownerOf(controllerId));
        _;
    }

    /// @inheritdoc INFTSmartWallet
    function execute(address target, bytes memory callData)
        external
        payable
        override
        onlyOwner
        returns (bytes memory)
    {
        return target.functionCallWithValue(callData, msg.value);
    }

    /// @inheritdoc INFTSmartWallet
    function execute(address target, bytes memory callData, uint256 value)
        external
        payable
        override
        onlyOwner
        returns (bytes memory)
    {
        return target.functionCallWithValue(callData, value);
    }

    /// @inheritdoc INFTSmartWallet
    function rawExecute(address target, bytes memory callData, uint256 value)
        external
        payable
        override
        onlyOwner
        returns (bytes memory)
    {
        (bool result, bytes memory message) = target.call{value: value}(callData);
        require(result, "Failed to execute");
        return message;
    }

    function owner() external view returns (address) {
        return controller.ownerOf(controllerId);
    }

    receive() external payable {
        // receive ETH
    }
}
