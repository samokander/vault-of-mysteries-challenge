// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract ClueFinder {
    uint256 public lockLevel;
    uint256 internal entered;
    uint256[] internal clues;
    address internal infiltrator;

    function findClue() external {
        // clear clues array
        delete clues;

        clues.push(2025);
        clues.push(0);
        clues.push(0);
        clues.push(0);
        clues.push(0);
    }
}
