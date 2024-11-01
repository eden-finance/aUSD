import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const aUSD = buildModule("aUSD", (m) => {
  
  const aUSD = m.contract("ERC20PermitOwnable",[]);

  return { aUSD };
});

export default aUSD;