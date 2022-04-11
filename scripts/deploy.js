// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const [accounts, usr1, usr2] = await hre.ethers.getSigners();
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
  const Factory = await hre.ethers.getContractFactory("UniswapV2Factory");
  const factory = await Factory.deploy(accounts.address);
  await factory.deployed();
  console.log("Factory deployed to:", factory.address);

  // deploy WETH9
  const WETH9 = await hre.ethers.getContractFactory("WETH9");
  const weth = await WETH9.deploy();
  await weth.deployed();
  console.log("WETH9 deployed to:", weth.address);

    
  // deploy Router UniswapV2
  const RouterV2 = await hre.ethers.getContractFactory("UniswapV2Router02");
  const router = await RouterV2.deploy(factory.address, weth.address);
  await router.deployed();
  console.log("RouterV2 deployed to:", router.address);

  // deploy SwapContract
  const SwapContract = await hre.ethers.getContractFactory("SwapContract");
  const swapContract = await SwapContract.deploy(dai.address, factory.address, router.address, weth.address);
  await swapContract.deployed();
  console.log("SwapContract deployed to:", swapContract.address);

console.log("\n------**********************---------\n");

  // passing 10 ethers, calling from acc2
  dai.mint(swapContract.address, "100000000000000000000");
  swapContract.connect(usr2).addNewLIquidity("100",{value:"1000"});
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
