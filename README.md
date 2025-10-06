# Vault of Mysteries Solidity Challenge

Welcome to the Vault of Mysteries challenge! Your goal is to unlock the
VaultOfMysteries smart contract and retrieve the funds stored there. This
challenge will test your ability to interact with EVM smart contracts,
understand Solidity code, and solve puzzles using on and off-chain tools and
techniques.

## Challenge Overview

You are provided with the Solidity source code for the `VaultOfMysteries`
contract. The contract is already deployed to a test network. Your task is to
unlock each level of the vault by interacting with the contract.

Each level requires a different approach, including:

- Calling contract functions
- Calling various `eth_` RPC methods
- Deploying your own contract to interact with the vault

## Getting Started

You will need:

- Access to an Ethereum wallet
- Some testnet ETH to pay for gas (we can provide this if needed)

## Contract Details

- **RPC Node URL:** `https://rpc1.bakerloo.autonity.org/`
- **Chain ID:** `65010004`
- **Network Name:** `Bakerloo Testnet`
- **Currency Symbol:** `ATN`
- **Block Explorer:** `https://bakerloo.autonity.org/`
- **Contract Address:** `0xf9c133C1f3359F58902578b2898601b8163b7FD7`
- **Faucet:** `https://autonity.faucetme.pro/`

## Rules

There really are no rules. The vault is designed to be unlocked in order, so
in general, we would expect that you have to call `level0()` before calling
`level1()`, and so on. However, if you can find a way to skip levels, or
complete them out of order, that is perfectly acceptable.

## Submission

Once you have unlocked all levels, submit:

- A brief write-up describing your approach for each level
- Any scripts or transactions you used
- The final transaction hash showing you unlocked the vault, and the funds
  were sent to your address

Don't worry if you cannot unlock all levels. The higher levels are designed to
be challenging and may require advanced techniques. We are interested in
learning about your approach and thought process.
