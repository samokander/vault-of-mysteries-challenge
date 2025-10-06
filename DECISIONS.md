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
Vault delegate calls the `investigator` contract hence vault's storage can be altered during the call.
For that `ClueFinder` contract will be deployed which will duplicate Valut's storage layout and alter `clues` array, satisfying `secret` requirement.

## Level 4

Requires calling `infiltrate()` on Solver's deployment (in constructor) to bypass both checks for `msg.sender.code.length == 0` in `infiltrate()` and `investigator.code.length > 0 && investigator == infiltrator` in `level4()`.

## Results

`0x3b545D1978EE2559DdE69E46344F5856419f7551` - EOA address that was used for solving the challenge.
`0xba48a499dcfea0816838052503530074d0a2cb47` - VaultSolver smart contract instance that was used for solving the challenge.
`0x83a7551be42a7301af36294d0af79f5b9420fa1d` - ClueFinder smart contract instance that was used for solving the challenge.
`0x6f7d66fbe9ea04bcaf863a6f6be3625d0f3659ebe6475b6f56623b5eaef6c904` - Actual drain transaction hash.

Each transaction' data is logged in the `broadcast/VaultSolver.s.sol/65010004/run-latest.json` file.

## Local Setup & Tooling

### Prerequisites

- Install the [Foundry](https://book.getfoundry.sh/getting-started/installation) toolchain (`forge`, `cast`, `anvil`).
- Have access to an Autonity Bakerloo RPC node with archive data at least up to the configured fork block.
- Fund a deployment account with enough ATN to cover gas if you intend to broadcast transactions.

### Environment Variables (`.env`)

1. Copy the example file and fill in the values you intend to use:

   ```bash
   cp .env.example .env
   ```

2. Update the three variables:
   - `RPC_URL` – HTTPS RPC endpoint for Bakerloo with archive access.
   - `BLOCK_NUMBER` – block height that already contains the deployed `VaultOfMysteries` contract (use `4685862` if you just need the provided snapshot).
   - `VAULT_ADDRESS` – target vault contract address (`0xf9c133C1f3359F58902578b2898601b8163b7FD7`).

### Deployment Parameters (`deploy-config/VaultSolverParams.json`)

The deployment script reads three fields:

- `initialOwner` – address that should immediately own the solver and receive any drained funds.
- `level1Key` – numeric secret required for `level1`. You can recover it with `cast storage` or by running the fork test.
- `vaultAddress` – the vault contract you want this solver to target. For the published challenge use `0xf9c133C1f3359F58902578b2898601b8163b7FD7`.

### Running the Tests

The fork tests require the RPC endpoint and block number from your `.env` file.

```bash
forge test -vvv
```

`VaultSolver.t.sol` will spin up a fork, verify each level unlock, and assert the vault balance drains to the configured hacker address.

### Deploying and Running the Solver Script

1. (Optional) Dry-run the script against a fork without broadcasting:

   ```bash
   source .env
   forge script script/VaultSolver.s.sol:VaultSolverScript --rpc-url $RPC_URL --fork-url $RPC_URL
   ```

2. Populate .env file with your signing private key `PRIVATE_KEY=0xabcdef123...123`

3. Broadcast the deployment and solve transactions to Bakerloo:

   ```bash
   source .env
   forge script script/VaultSolver.s.sol:VaultSolverScript \
     --rpc-url $RPC_URL \
     --broadcast \
     --private-key $PRIVATE_KEY \
     -vv
   ```

The script deploys a fresh `ClueFinder` and `VaultSolver`, calls each solve method in order, and should produce a `run-latest.json` artifact under `broadcast/` summarizing the transactions.
