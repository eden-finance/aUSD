import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const USDC_ADDRESS = "0x5A6b3cc4c7275E0Ea4F2ADa35Df4a47410D9d6Df"
const A_USDC = "0x8BBA4FE91B9FA3C559d007AD19d05A86A810dd29"

const aUSDManagerModule = buildModule("aUSDManagerModule", (m) => {

  const aUSDToken = m.contractAt("ERC20PermitOwnable","0xA70C70A3F58729152f10D95Aa0B2DaaaBc64f5F4")
  

  const aUSDManager = m.contract("aUSDManager",[aUSDToken,USDC_ADDRESS,A_USDC]);

    const USDCToken = m.contractAt("ERC20PermitOwnable",USDC_ADDRESS,{
      id:"usdc"
    })
   
  return { aUSDManager,USDCToken };
});

export default aUSDManagerModule;