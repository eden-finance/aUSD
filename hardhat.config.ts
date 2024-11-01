import type { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import "@nomicfoundation/hardhat-ethers";

import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.27",
  networks: {
      "assetchain-testnet": {
      url: process.env.NETWORK_RPC,
      chainId: 42421, 
      accounts: [process.env.PRIVATE_KEY || ''],
    },
    
  },
   sourcify: {
    enabled: false
  },
  etherscan:{
     apiKey: {
      "assetchain-testnet":"abc"
    },
    customChains:[
       {
        network: "assetchain-testnet",
        chainId: 42421,
        urls: {
          apiURL: "https://scan-testnet.assetchain.org/api",
          browserURL: "https://scan-testnet.assetchain.org/"
        }
      }
    ]
  }
};

export default config;
