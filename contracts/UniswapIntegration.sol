//SPDX-License-Identifier: <SPDX-License>
pragma solidity >=0.6.6;

import "@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IERC20.sol";
import "hardhat/console.sol";

contract UniswapIntegration {
    IUniswapV2Router02 routerContract;
    IUniswapV2Factory factoryContract;
    IUniswapV2Pair pairContract;
    address public router;
    address public factory;
    IERC20 token1;
    IERC20 token2;

    constructor(address _factory, address _routerAddress) public {
        router = _routerAddress;
        factory = _factory;
        routerContract = IUniswapV2Router02(_routerAddress);
        factoryContract = IUniswapV2Factory(_factory);
        //factoryAddress = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
        //routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    }

    // function pairInfo(address tokenA, address tokenB) internal view returns(uint reserveA, uint reserveB, uint totalSupply) {
    //     IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, tokenA, tokenB));
    //     totalSupply = pair.totalSupply();
    //     (uint reserves0, uint reserves1,) = pair.getReserves();
    //     (reserveA, reserveB) = tokenA == pair.token0()? (reserves0, reserves1) : (reserves1, reserves0);
    // }

    // function compute


    //Adding Liquidity

    function addingLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline)
        public returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
            token1 = IERC20(tokenA);
            token2 = IERC20(tokenB);

            require(token1.transferFrom(msg.sender, address(this), amountADesired), "addingLiquidity: Token Transfer Failed");
            require(token2.transferFrom(msg.sender, address(this), amountBDesired), "addingLiquidity: Token Transfer Failed");
            
            require(token1.approve(router, amountADesired), "addingLiquidity: Token A, Approve Failed");
            require(token2.approve(router, amountBDesired), "addingLiquidity: Token B, Approve Failed");
            
            return routerContract.addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin, to, deadline);
    }

    function addingLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) 
        public payable returns (uint amountToken, uint amountETH, uint liquidity) {
            token1 = IERC20(token);
            require(token1.transferFrom(msg.sender, address(this), amountTokenDesired), "addingLiquidityETH: Token Transfer Failed");
            require(token1.approve(address(routerContract), amountTokenDesired), "addingLiquidityETH: Token Approve Failed");
            return routerContract.addLiquidityETH{value:msg.value}(token, amountTokenDesired, amountTokenMin, amountETHMin, to, deadline);
    }

    //Removing Liquidity
    
    function removingLiquidity(address tokenA, address tokenB, uint liquidity, address to, uint deadline)
        public returns (uint amountA, uint amountB) {
            uint amountAMin = 0;
            uint amountBMin = 0;
            address pool = factoryContract.getPair(tokenA, tokenB);
            require(IUniswapV2Pair(pool).transferFrom(msg.sender, address(this), liquidity), "removingLiquidity: Token Transfer Failed");
            require(IUniswapV2Pair(pool).approve(address(routerContract), liquidity), "removingLiquidity: Token Approve Failed");
            return routerContract.removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
    }

    function removingLiquityETH(address token, uint liquidity, address to, uint deadline)
        public returns (uint amountToken, uint amountETH) {
            uint amountTokenMin = 0;
            uint amountETHMin = 0;
            address pool = factoryContract.getPair(token, routerContract.WETH());
            require(IUniswapV2Pair(pool).transferFrom(msg.sender, address(this), liquidity), "removingLiquidity: Token Transfer Failed");
            require(IUniswapV2Pair(pool).approve(address(routerContract), liquidity), "removingLiquidity: Token Approve Failed");
            return routerContract.removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
    }

    //Swapping

    function swappingExactTokensForTokens(address tokenIn, address tokenOut, uint amountIn, uint amountOutMin, address[] memory path, address to, uint deadline) public {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        routerContract.swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline);
    }

    function swappingTokensForExactTokens(address tokenOut, address tokenIn, uint amountOut, uint amountInMax, address[] memory path, address to, uint deadline) public {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        routerContract.swapTokensForExactTokens(amountOut, amountInMax, path, to, deadline);
    }

    function swappingExactETHForTokens(address tokenOut, uint amountOutMin, address[] memory path, address to, uint deadline) public payable {
        address[] memory path = new address[](2);
        path[0] = routerContract.WETH();
        path[1] = tokenOut;
        routerContract.swapExactETHForTokens{value:msg.value}(amountOutMin, path, to, deadline);
    }
    
    function swappingTokensForExactETH(address tokenIn, uint amountOut, uint amountInMax, address to, uint deadline) public {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = routerContract.WETH();
        routerContract.swapTokensForExactETH(amountOut, amountInMax, path, to, deadline);
    }

    function swappingExactTokensForETH(address tokenIn, uint amountIn, address to, uint deadline) public {
        token1 = IERC20(tokenIn);
        // address pool = factoryContract.getPair(tokenIn, routerContract.WETH());
        // pairContract = IUniswapV2Pair(pool);
        // (uint reserveIn, uint reserveOut,) = pairContract.getReserves();

        // uint amountOut = UniswapV2Library.getAmountsOut(amountIn, reserveIn, reserveOut);
        // uint amountOutMin = (10 * amountOut) / 100;
        // uint amountOutMin = 0;
        // uint amountOutMin = 22276662263378792460;

        require(token1.transferFrom(msg.sender, address(this), amountIn), "swappingExactTokensForETH: Token Transfer Failed");
        require(token1.approve(address(routerContract), amountIn), "swappingExactTokensForETH: Token Approve Failed");
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = routerContract.WETH();
        routerContract.swapExactTokensForETH(amountIn, amountOutMin, path, to, deadline);
    }
    
    function swappingETHForExactTokens(address tokenOut, uint amountOut, address to, uint deadline) public payable {
        // token1 = IERC20(tokenIn);
        // address pool = factoryContract.getPair(tokenOut, routerContract.WETH());
        // pairContract = IUniswapV2Pair(pool);
        // (uint reserveIn, uint reserveOut,) = pairContract.getReserves();

        // uint amountIn = UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
        // require(token1.transferFrom(msg.sender, address(this), amountIn), "swappingExactTokensForETH: Token Transfer Failed");
        // require(token1.approve(address(routerContract), amountIn), "swappingExactTokensForETH: Token Approve Failed");
        // address[] memory path = new address[](2);
        // path[0] = routerContract.WETH();
        // path[1] = tokenOut;
        // routerContract.swapETHForExactTokens{value:msg.value}(amountOut, path, to, deadline);
    }

}
