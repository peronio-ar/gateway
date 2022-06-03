// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled

  // We get the contract to deploy
  const GatewayFactory = await ethers.getContractFactory("GatewayFactory");

  const currencyAddress = "0x448aa1665fe1fae6d1a00a9209ea62d7dcd81a4b";
  const owner = "0x448aa1665fe1fae6d1a00a9209ea62d7dcd81a4b";

  const gatewayFactory = await GatewayFactory.deploy();
  await gatewayFactory.deployed();

  const gateway = await gatewayFactory.createGateway(currencyAddress, owner);

  console.info("lenght: ", await gatewayFactory.gateswaysLength());

  console.info(gateway);

  // console.log("Gateway deployed to:", gateway.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
