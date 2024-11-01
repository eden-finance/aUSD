import hre from "hardhat";
import aUSDModule from "../ignition/modules/aUSD";
import aUSDManagerModule from "../ignition/modules/aUSDManager"

async function main() {
  const  {aUSD}  = await hre.ignition.deploy(aUSDModule);

  const  {aUSDManager}  = await hre.ignition.deploy(aUSDManagerModule);
  await aUSD.write.transferOwnership([aUSDManager.address])

}

main().catch(console.error);