// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface INFTSmartWalletFactoryEvents {
    event WalletCreated(address indexed wallet, address indexed owner);
}

interface INFTSmartWalletFactory is INFTSmartWalletFactoryEvents {
    function createWallet() external returns (address wallet);

    function createWallet(address owner) external returns (address wallet);

    function walletExists(address wallet) external view returns (bool);
}
