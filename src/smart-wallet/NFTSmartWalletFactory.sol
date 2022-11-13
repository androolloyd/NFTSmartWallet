// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {Clones} from "./utils/Clones.sol";
import {NFTSmartWallet} from "./NFTSmartWallet.sol";
import {INFTSmartWallet} from "./interfaces/INFTSmartWallet.sol";
import {INFTSmartWalletFactory} from "./interfaces/INFTSmartWalletFactory.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";

/// @title NFT smart wallet factory
contract NFTSmartWalletFactory is INFTSmartWalletFactory, ERC721("NFT Smart Wallet", "NFT-SW") {

    /// @dev Address of the contract to clone from
    address public immutable masterWallet;
    uint256 public tokenCount = 0;

    /// @dev Whether a wallet is created by this factory
    /// @notice Can be used to verify that the address is actually
    ///         NFTSmartWallet and not an impersonating malicious
    ///         account
    mapping(address => bool) public walletExists;

    constructor() {
        _mint(address(this), 0);
        unchecked {
            tokenCount++;
        }
        masterWallet = address(new NFTSmartWallet());

        emit WalletCreated(masterWallet, address(this));
    }

    function createWallet() external returns (address wallet) {
        wallet = _createWallet(msg.sender);
    }

    function createWallet(address owner) external returns (address wallet) {
        wallet = _createWallet(owner);
    }

    function _createWallet(address owner) internal returns (address wallet) {
        require(owner != address(0));

        wallet = Clones.clone(masterWallet);
        uint256 newId = tokenCount;
        tokenCount++;
        _mint(owner, newId);
        INFTSmartWallet(wallet).initialize(newId);
        walletExists[wallet] = true;

        emit WalletCreated(wallet, owner);
    }



    function tokenURI(uint256 id) public view override(ERC721) virtual returns (string memory) {
        //cool svg nft

        //generate a cool svg

        return string(abi.encodePacked("json"));
    }
}
