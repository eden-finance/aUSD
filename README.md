# aUSD Yield Bearing StableCoin

## Overview

aUSD is a yield-bearing stablecoin that enables users to deposit USDC into a smart contract, mint an equivalent amount of aUSD, and earn interest. Deposited USDC is supplied to Eden Finance, a fork of Aave on AssetChain, where it accrues interest. aUSD can be freely traded like a regular stablecoin, maintaining value stability through a 1:1 peg to USDC.


###  Verify aUSD Contract

```
npx hardhat verify --network assetchain-testnet <DEPLOYED_TOKEN_ADDRESS>

npx hardhat verify --network assetchain-testnet 0x670141727B0E2d2CbBC6161CC23b385BDBE460e2 0x79057060c72178d30A91292e63cca26e2D654012 0x5A6b3cc4c7275E0Ea4F2ADa35Df4a47410D9d6Df
```

### Deploy and Verify Manager

```


npx hardhat ignition deploy ignition/modules/aUSD.ts --network assetchain-testnet --verify --reset

npx hardhat ignition deploy ignition/modules/aUSDManager.ts --network assetchain-testnet --verify --reset

npx hardhat run scripts/transfer-ownership.ts --network assetchain-testnet
npx hardhat run scripts/deposit.ts --network assetchain-testnet

```

### Scripts

```
npx hardhat run scripts/transfer-ownership.ts --network assetchain-testnet
```

### Deployed Contract

- aUSD ERC20 Token: 0x79057060c72178d30A91292e63cca26e2D654012
