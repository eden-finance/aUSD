import hre from "hardhat";
import ManagerModule from "../ignition/modules/aUSDManager";

async function main() {


 const { aUSDManager, USDCToken } = await hre.ignition.deploy(ManagerModule);
 const [senderAccount] = await hre.ethers.getSigners()
 const senderAddress = await senderAccount.getAddress()
 
 console.log(`Signer: `,senderAddress)

 console.log(`Manager: ${aUSDManager.address}`)

  const depositAmount = BigInt(3*10**6); // Replace with the amount you want to deposit

  // Approve the aUSDManager contract to spend USDC on behalf of the sender
  await USDCToken.write.approve([aUSDManager.address, depositAmount]);

  const allowance = await USDCToken.read.allowance([senderAddress,aUSDManager.address])

  console.log(`Allowance: ${allowance}`)
  // Now call the deposit function after approval
  const txn = await aUSDManager.write.deposit([depositAmount]);

  console.log(`Deposit: ${txn}`)
}

main().catch(console.error);