# Walk Through

Solver testing will be handled on Autonity mainnet fork at block where `VaultOfMysteries` contract was already present.

```bash
source .env
anvil --fork-url $RPC_URL --fork-block-number $BLOCK_NUMBER
```

## Level 0

Just calling level0() is enough.

## Level 1

Accepts value as a parameter. We should pass value at `keccak256("level1.storage")` position of the vault contract.

```bash
chisel

> keccak256("level1.storage")
Type: bytes32
└ Data: 0x22eb28c83bb42c5c2a9f294d885113bf1046cf5ce0a3a6b672242a78a31176a0
```

```bash
cast storage 0xf9c133C1f3359F58902578b2898601b8163b7FD7 0x22eb28c83bb42c5c2a9f294d885113bf1046cf5ce0a3a6b672242a78a31176a0
```

The result is `0x0000000000000000000000000000000000000000000000000000000000845fed`.

```bash
cast to-dec 0x0000000000000000000000000000000000000000000000000000000000845fed
```

Casting to decimals that will be `8675309`.

So key to level 1 is `8675309`.

We can simplify this in code using Foundry `load` VM cheatcode.

## Level 2

Accepts `investigator` address which has to implement `investigate()` function.
We'll implement `investigate()` function in the Solver contract itself.
Fails if entered < 11 so we'll have to reenter at least 11 times to unlock level.

## Level 3

Accepts `investigator` address which has to implement `findClue()` function.
For that `ClueFinder` contract will be deployed which will duplicate Valut's storage layout and alter `clues` array.

## Level 4

Requires calling `infiltrate()` on Solver deployment (in constructor) to bypass both checks for `msg.sender.code.length == 0` in `infiltrate()` and `investigator.code.length > 0` in `level4()`.
