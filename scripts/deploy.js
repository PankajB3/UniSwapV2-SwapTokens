// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // deploy DAI Contract
  const DAI = await hre.ethers.getContractFactory("DAI");
  const dai = await DAI.deploy();
  await dai.deployed();
  console.log("DAI deployed to:", dai.address);

  // deploy factory UniswapV2
  const Factory = await hre.ethers.getContractFactory("FactoryV2");
  const factory = await Factory.deploy();
  await factory.deployed();
  console.log("Factory deployed to:", factory.address);
  
  // deploy Router UniswapV2
  const RouterV2 = await hre.ethers.getContractFactory("RouterV2");
  const router = await RouterV2.deploy();
  await router.deployed();
  console.log("RouterV2 deployed to:", router.address);

  // deploy WETH9
  const WETH9 = await hre.ethers.getContractFactory("WETH9");
  const weth = await WETH9.deploy();
  await weth.deployed();
  console.log("WETH9 deployed to:", weth.address);

  // deploy SwapContract
  const SwapContract = await hre.ethers.getContractFactory("SwapContract");
  const swapContract = await SwapContract.deploy(dai.address, factory.address, router.address, weth.address);
  await swapContract.deployed();
  console.log("SwapContract deployed to:", swapContract.address);



  // passing 10 ethers
  // swapContract.addNewLiquidity(10000000000000000000);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
