import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const aUSD = buildModule("aUSD", (m) => {
  
  const aUSD = m.contract("aUSDToken",[]);

  return { aUSD };
});

export default aUSD;