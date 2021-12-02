
const hre = require("hardhat");
const ethers = hre.ethers;

const pairContract = require("../artifacts/@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol/IUniswapV2Pair.json");
const libContract = require("../artifacts/@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol/UniswapV2Library.json");
const routerContract = require("../artifacts/@uniswap/v2-periphery/contracts/UniswapV2Router02.sol/UniswapV2Router02.json");

async function main() {
  // await hre.run("compile");
  accounts = await hre.ethers.getSigners();
  const UniswapInt = await ethers.getContractFactory("UniswapIntegration");
  // const uniswap = await UniswapInt.deploy("0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f","0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D");
  const UniAddress = '0x8d88E1f8cB7557777684e0ec412d252b94AC5c5F';
  const uniswap = new ethers.Contract(UniAddress, UniswapInt.interface, accounts[0]);

  // await uniswap.deployed();
  // console.log("Contract deployed at: ", uniswap.address);

  const ERC20_test = await ethers.getContractFactory("TestToken");
  // // const testTokenAddress = '0xe151152d524ccae54ae9e2572c1168f521bce42c'; // first deployment
  const testTokenAddress = '0xC7f156A27bb562DD76E711aD49C2e9C3CD5089F4'; //current
  const erc20 = new ethers.Contract(testTokenAddress, ERC20_test.interface, accounts[0]);

  // const poolAddress = '0x78Fc3fb245e0F0861b5ded3B7d7974F786f954cC';
  // const pool = new ethers.Contract(poolAddress, ERC20_test.interface, accounts[0]);
  
  const poolAddress = '0x78Fc3fb245e0F0861b5ded3B7d7974F786f954cC';
  const pool = new ethers.Contract(poolAddress, pairContract.abi, accounts[0]);

  const ERC20_swap = await ethers.getContractFactory("SwapToken");
  // const swapTokenAddress = '0x260525deD6Ab4Bc433d8633DaB8D39D286cEAbfB'; // first deployment
  const swapTokenAddress = '0xFC1dfA2bd1F9eD85DB32c0cc92B8603839C94822'; // current
  const erc20b = new ethers.Contract(swapTokenAddress, ERC20_swap.interface, accounts[0]);

  const router = new ethers.Contract('0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D', routerContract.abi, accounts[0]);
  // const pairaddress = '0x3356c9A8f40F8E9C1d192A4347A76D18243fABC5';
  // const pair = new ethers.Contract(pairaddress,pairContract.abi,accounts[0]);

  const libaddress = '0x9aC08370A3803A2A108052e2F7CD345288399dBc';
  const library = new ethers.Contract(libaddress,libContract.abi,accounts[0]);

  // await erc20.mint('0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9', ethers.utils.parseUnits("10000", "ether"));
  // await erc20b.mint('0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9', ethers.utils.parseUnits("10000", "ether"));

  await erc20.connect(accounts[0]).approve(UniAddress,ethers.utils.parseUnits("1000", "ether"));
  // await erc20b.connect(accounts[0]).approve(UniAddress,ethers.utils.parseUnits("2000", "ether"));
  // const approvepool = await pool.connect(accounts[0]).approve(UniAddress,ethers.utils.parseUnits("5", "ether"));
  // console.log("tx hash: ", approvepool.hash);

  // const approvepool = await erc20.connect(pool).approve(UniAddress,ethers.utils.parseUnits("120", "ether"));

  // const LiqAdd = await uniswap.addingLiquidityETH(testTokenAddress, ethers.utils.parseUnits("100", "ether"),
  //   ethers.utils.parseUnits("0.00001", "ether"), ethers.utils.parseUnits("0.00001", "ether"), "0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9", 1749796297, {
  //     value: ethers.utils.parseUnits("1", "ether"),
  //     maxFeePerGas: ethers.utils.parseUnits("100", "gwei"),
  //     maxPriorityFeePerGas: ethers.utils.parseUnits("10", "gwei")
  // });
  // LiqAdd.wait();
  // console.log("Liquidity tx hash: ", LiqAdd.hash)

  // const LiqAdd = await uniswap.addingLiquidity(testTokenAddress, swapTokenAddress,
  //   ethers.utils.parseUnits("100", "ether"), ethers.utils.parseUnits("200", "ether"),
  //   ethers.utils.parseUnits("99", "ether"), ethers.utils.parseUnits("198", "ether"),
  //   "0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9", 1749796297, {
  //     maxFeePerGas: ethers.utils.parseUnits("100", "gwei"),
  //     maxPriorityFeePerGas: ethers.utils.parseUnits("10", "gwei")
  // });
  // console.log("Liquidity Has been Added: ", LiqAdd.hash)

  const amount = await router.getAmountOut(ethers.utils.parseUnits("5", "ether"),
    ethers.utils.parseUnits("150", "ether"), ethers.utils.parseUnits("1.5", "ether"))
    console.log("Amount Out: ", amount);

  // const balance = await erc20.balanceOf("0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9");
  // console.log(balance);

  // const LiqRemove = await uniswap.removingLiquityETH(testTokenAddress, ethers.utils.parseUnits("5", "18"), 
  //   "0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9", 1749796297);
  // console.log("Removing Liquidity Tx: ", LiqRemove.hash);

  // const LiqRemove = await uniswap.removingLiquidity(testTokenAddress, swapTokenAddress, 
  //   ethers.utils.parseUnits("10", "ether"), "0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9", 1749796297);
  // console.log("Removing Liquidity Tx: ", LiqRemove.hash);

  const swapExactTokforEth = await uniswap.connect(accounts[0]).swappingExactTokensForETH(testTokenAddress, ethers.utils.parseUnits("5", "18"),
  "0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9", 1749796297);
  console.log("Swap Exact Tokens for ETH Tx: ", swapExactTokforEth.hash);

  // const swapEthforExactTok = await uniswap.connect(accounts[0]).swappingETHForExactTokens(testTokenAddress, ethers.utils.parseUnits("10", "ether"),
  //   "0x621812bF225D4A7bF6e2bCA6eBa63Ce957E3cDe9", 1749796297);
  //   console.log("Swap Exact Tokens for ETH Tx: ", swapEthforExactTok.hash);
  
  // const reser = await pool.getReserves();
  // const amountOut = await library.getAmountOut(ethers.utils.parseUnits("10", "ether"),reser.reserveIn, reser.reserveOut);
  // console.log("value: ", amountOut);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });