import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const USDC_ADDRESS = "0x5A6b3cc4c7275E0Ea4F2ADa35Df4a47410D9d6Df"

const aUSDManagerModule = buildModule("aUSDManagerModule", (m) => {

  const aUSDToken = m.contractAt("ERC20PermitOwnable","0xb290eCB125A53263D3D2AA4a8fd1b42e95A49D8B")


  const aUSDManager = m.contract("aUSDManager",[aUSDToken,USDC_ADDRESS]);

    const USDCToken = m.contractAt("ERC20PermitOwnable",USDC_ADDRESS,{
      id:"usdc"
    })
   
  return { aUSDManager,USDCToken };
});

export default aUSDManagerModule;