import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const aUSDManagerModule = buildModule("aUSDManagerModule", (m) => {
  const aUSDToken = m.contractAt("aUSDToken","0x79057060c72178d30A91292e63cca26e2D654012")
  const USDC_ADDRESS = "0x5A6b3cc4c7275E0Ea4F2ADa35Df4a47410D9d6Df"

  const aUSDManager = m.contract("aUSDManager",[aUSDToken,USDC_ADDRESS]);

  return { aUSDManager };
});

export default aUSDManagerModule;