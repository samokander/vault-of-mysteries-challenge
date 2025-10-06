// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

library Level1 {
    struct LevelStorage {
        uint256 value;
    }

    function getStorage() internal pure returns (LevelStorage storage ls) {
        bytes32 position = keccak256("level1.storage");
        assembly {
            ls.slot := position
        }
    }

    function setValue(uint256 _value) internal {
        LevelStorage storage ls = getStorage();
        ls.value = _value;
    }

    function checkValue(uint256 _value) internal view returns (bool) {
        LevelStorage storage ls = getStorage();
        return ls.value == _value;
    }
}

interface ILevel2 {
    function investigate() external;
}

contract VaultOfMysteries {
    uint256 public lockLevel;
    uint256 internal entered;
    uint256[] internal clues;
    address internal infiltrator;

    event VaultUnlocked(uint256 level, string message);

    constructor(uint256 value) payable {
        lockLevel = 0;
        Level1.setValue(value);
        entered = 0;
    }

    modifier onlyIfUnlocked(uint256 requiredLevel) {
        require(lockLevel >= requiredLevel, "Vault level is locked");
        _;
    }

    modifier markEntry() {
        entered += 1;
        _;
        entered -= 1;
    }

    modifier noInfiltrators() {
        address before = infiltrator;
        _;
        require(before == infiltrator, "Infiltrator detected");
    }

    /// Level 0: Calling functions
    function level0() public onlyIfUnlocked(0) {
        lockLevel = 1; // unlock next level
        emit VaultUnlocked(1, "Level 0: You found a rusty key");
    }

    /// Level 1: reading internal storage
    function level1(uint256 value) public onlyIfUnlocked(1) {
        require(Level1.checkValue(value), "Level 1: Incorrect value");
        lockLevel = 2; // unlock next level
        emit VaultUnlocked(2, "Level 1: You deciphered the ancient script");
    }

    /// Level 2: re-entrancy
    function level2(address investigator) public onlyIfUnlocked(2) markEntry {
        ILevel2(investigator).investigate();
        if (lockLevel < 3) {
            require(entered >= 11, "Level 2: Investigation failed");
        }
        lockLevel = 3; // unlock next level
        emit VaultUnlocked(3, "Level 2: You solved the riddle of the Sphinx");
    }

    /// Level 3: delegatecall
    function level3(address investigator) public onlyIfUnlocked(3) noInfiltrators {
        investigator.delegatecall(abi.encodeWithSignature("findClue()"));
        require(clues.length >= 5, "Level 3: Not enough clues found");
        uint256 secret = 0;
        for (uint256 i = 0; i < clues.length; i++) {
            secret += clues[i];
        }
        require(secret == 2025, "Level 3: Incorrect secret");
        lockLevel = 4; // unlock next level
        emit VaultUnlocked(4, "Level 3: You unlocked the final chamber");
    }

    /// Level 4: smart contract wallet
    function level4(address investigator) public onlyIfUnlocked(4) {
        require(investigator == infiltrator, "Level 4: Investigator never made it in");
        require(investigator.code.length > 0, "Level 4: Investigator kicked out");
        lockLevel = 5; // unlock next level
        emit VaultUnlocked(5, "Level 4: You have stolen the gold from Vault of Mysteries!");
        // Transfer all Ether to the caller
        msg.sender.call{value: address(this).balance}("");
    }

    function infiltrate() external {
        require(msg.sender.code.length == 0, "Infiltrator detected");
        infiltrator = msg.sender;
    }
}
