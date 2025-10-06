// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {VaultOfMysteries} from "src/VaultOfMysteries.sol";
import {VaultSolver} from "src/VaultSolver.sol";
import {ClueFinder} from "src/ClueFinder.sol";

contract VaultSolverForkTest is Test {
    address internal constant VAULT_ADDRESS = 0xf9c133C1f3359F58902578b2898601b8163b7FD7;
    // keccak256("level1.storage")
    bytes32 internal constant LEVEL1_SLOT = 0x22eb28c83bb42c5c2a9f294d885113bf1046cf5ce0a3a6b672242a78a31176a0;

    uint256 internal level1Secret;
    VaultOfMysteries internal vault;
    VaultSolver internal solver;
    ClueFinder internal clueFinder;

    address hacker = makeAddr("hacker");

    function setUp() public {
        level1Secret = uint256(vm.load(VAULT_ADDRESS, LEVEL1_SLOT));
        string memory rpcUrl = vm.envString("RPC_URL");
        uint256 blockNumber = vm.envUint("BLOCK_NUMBER");
        vm.createSelectFork(rpcUrl, blockNumber);

        vm.startPrank(hacker);
        vault = VaultOfMysteries(VAULT_ADDRESS);
        clueFinder = new ClueFinder();
        solver = new VaultSolver(VAULT_ADDRESS, clueFinder, hacker);
    }

    function test_UnlockLevel0() public {
        vm.startPrank(hacker);
        vm.expectEmit();
        emit VaultOfMysteries.VaultUnlocked(1, "Level 0: You found a rusty key");
        solver.solveLevel0();
    }

    function test_UnlockLevel1() public {
        vm.startPrank(hacker);
        solver.solveLevel0();
        vm.expectEmit();
        emit VaultOfMysteries.VaultUnlocked(2, "Level 1: You deciphered the ancient script");
        solver.solveLevel1(level1Secret);
    }

    function test_UnlockLevel2() public {
        vm.startPrank(hacker);
        solver.solveLevel0();
        solver.solveLevel1(level1Secret);
        vm.expectEmit();
        emit VaultOfMysteries.VaultUnlocked(3, "Level 2: You solved the riddle of the Sphinx");
        solver.solveLevel2();
    }

    function test_UnlockLevel3() public {
        vm.startPrank(hacker);
        solver.solveLevel0();
        solver.solveLevel1(level1Secret);
        solver.solveLevel2();
        vm.expectEmit();
        emit VaultOfMysteries.VaultUnlocked(4, "Level 3: You unlocked the final chamber");
        solver.solveLevel3();
    }

    function test_UnlockLevel4() public {
        vm.startPrank(hacker);
        solver.solveLevel0();
        solver.solveLevel1(level1Secret);
        solver.solveLevel2();
        solver.solveLevel3();
        uint256 hackerBalanceBefore = hacker.balance;
        uint256 vaultBalanceBefore = address(vault).balance;
        vm.expectEmit();
        emit VaultOfMysteries.VaultUnlocked(5, "Level 4: You have stolen the gold from Vault of Mysteries!");
        solver.solveLevel4();
        assertEq(address(vault).balance, 0, "Vault balance not zero after level 4");
        assertEq(
            address(hacker).balance,
            hackerBalanceBefore + vaultBalanceBefore,
            "Solver balance not correct after level 4"
        );
    }
}
