// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {VaultSolver} from "src/VaultSolver.sol";
import {ClueFinder} from "src/ClueFinder.sol";

contract VaultSolverScript is Script {
    address vaultAddress;
    uint256 level1Secret;
    address initialOwner;

    function setUp() public {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/deploy-config/VaultSolverParams.json");
        string memory json = vm.readFile(path);

        initialOwner = vm.parseJsonAddress(json, ".initialOwner");
        level1Secret = vm.parseJsonUint(json, ".level1Key");
        vaultAddress = vm.parseJsonAddress(json, ".vaultAddress");
    }

    function run() public {
        vm.startBroadcast();

        ClueFinder clueFinder = new ClueFinder();
        VaultSolver solver = new VaultSolver(vaultAddress, address(clueFinder), initialOwner);
        solve(solver);
        vm.stopBroadcast();
    }

    function solve(VaultSolver solver) internal {
        solver.solveLevel0();
        console.log("Level 0 solved");
        solver.solveLevel1(level1Secret);
        console.log("Level 1 solved");
        solver.solveLevel2();
        console.log("Level 2 solved");
        solver.solveLevel3();
        console.log("Level 3 solved");
        solver.solveLevel4();
        console.log("Level 4 solved");
    }
}
