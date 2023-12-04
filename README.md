# Status Network Token V2 [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gha]: https://github.com/status-im/status-network-token-v2/actions
[gha-badge]: https://github.com/status-im/status-network-token-v2/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

This is the second iteration of [Status Network Token](https://github.com/status-im/status-network-token). The original
version of the token uses a lot of legacy code. This repository implements a more modern version based on our
[MiniMeToken](https://github.com/vacp2p/minime) fork.

## Deployments

| **Contract**       | **Address**                                                                                                                     | **Snapshot**                                                                                                     |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **Sepolia**        |                                                                                                                                 |                                                                                                                  |
| SNTV2              | [`0xE452027cdEF746c7Cd3DB31CB700428b16cD8E51`](https://sepolia.etherscan.io/address/0xE452027cdEF746c7Cd3DB31CB700428b16cD8E51) | [`2ac31e`](https://github.com/status-im/status-network-token-v2/commit/2ac31ea230cd9e89eff700b65da8a8b8024f3d79) |
| SNTTokenController | [`0x785e6c5af58FB26F4a0E43e0cF254af10EaEe0f1`](https://sepolia.etherscan.io/address/0x785e6c5af58FB26F4a0E43e0cF254af10EaEe0f1) | [`2ac31e`](https://github.com/status-im/status-network-token-v2/commit/2ac31ea230cd9e89eff700b65da8a8b8024f3d79) |

## Usage

This is a list of the most frequently needed commands.

### Build

Build the contracts:

```sh
$ forge build
```

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Compile

Compile the contracts:

```sh
$ forge build
```

### Coverage

Get a test coverage report:

```sh
$ forge coverage
```

### Deploy

Deploy to Anvil:

```sh
$ forge script script/Deploy.s.sol --broadcast --fork-url http://localhost:8545
```

For this script to work, you need to have a `MNEMONIC` environment variable set to a valid
[BIP39 mnemonic](https://iancoleman.io/bip39/).

For instructions on how to deploy to a testnet or mainnet, check out the
[Solidity Scripting](https://book.getfoundry.sh/tutorials/solidity-scripting.html) tutorial.

### Format

Format the contracts:

```sh
$ forge fmt
```

### Gas Usage

Get a gas report:

```sh
$ forge test --gas-report
```

### Lint

Lint the contracts:

```sh
$ pnpm lint
```

#### Fixing linting issues

For any errors in solidity files, run `forge fmt`. For errors in any other file type, run `pnpm prettier:write`.

### Test

Run the tests:

```sh
$ forge test
```

## Notes

1. Foundry uses [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to manage dependencies. For
   detailed instructions on working with dependencies, please refer to the
   [guide](https://book.getfoundry.sh/projects/dependencies.html) in the book
2. You don't have to create a `.env` file, but filling in the environment variables may be useful when debugging and
   testing against a fork.
