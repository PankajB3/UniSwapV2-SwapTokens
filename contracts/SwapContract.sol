// SPDX-License-Identifier:MIT

pragma solidity >=0.8.0;

// import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract SwapContract {
    // address private Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    // address private Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private Factory;
    address private Router;
    address[] private path;
    constructor(address _factory, address _router, address usdtAddr, address usdcAddr, address daiAddr) {
        Factory = _factory;
        Router = _router;
         //    create path
        path[0] = 0xc778417E063141139Fce010982780140Aa0cD5Ab;   //   WETH9(Rinkeby)
        path[1] = usdcAddr;
        path[2] = usdtAddr;
        path[3] = daiAddr;
    }

    // function createNewPair(address tokenA, address tokenB) external returns(address){
    //    address addr =  IUniswapV2Factory(Factory).createPair(tokenA, tokenB);
    //    return addr;
    // }

    function addNewLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired
    )
        public
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        // here amountAMin = amountBMin = 1
        // deadline = block.timestamp

        IERC20(tokenA).transferFrom(msg.sender, address(this), amountADesired);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountBDesired);
        IERC20(tokenA).approve(Router, amountADesired);
        IERC20(tokenB).approve(Router, amountBDesired);

        (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        ) = IUniswapV2Router02(Router).addLiquidity(
                tokenA,
                tokenB,
                amountADesired,
                amountBDesired,
                1,
                1,
                address(this),
                block.timestamp + 15 minutes
            );
        return (amountA, amountB, liquidity);
    }

    receive() external payable {}

    // ether i/p
    function swapMyEth() external payable returns (uint256[] memory, uint256[] memory, uint256[] memory) {
        uint256[] memory arr;
       
        uint256 value = msg.value;
        uint256 i = 0;

       if(value % 3 != 0){
            while (value > 0 && i<=1) {
            uint256 amt = value / 3;
            arr[i] = amt;
            value -= amt;
            i++;
        }
        arr[2] = value;
       }else{
            while (value > 0) {
                uint256 amt = value / 3;
                arr[i] = amt;
                value -= amt;
                i++;
            }
       }
       uint256[] memory amtToUSDC =   ethToDAI(path, arr[0]);
        uint256[] memory amtToUSDT =  ethToDAI(path, arr[1]);       
       uint256[] memory amtToDAI =   ethToDAI(path, arr[2]);

        return (amtToDAI, amtToUSDC, amtToUSDT);
    }
    function ethToDAI(address[] memory arr, uint256 amt) internal returns(uint256[] memory){
         uint256[] memory resAmt =  IUniswapV2Router02(Router).swapExactETHForTokens(
            amt, arr, address(this), block.timestamp + 30 minutes
        );
        return resAmt;
    }
    function ethToUSDT(address[] memory arr, uint256 amt) internal returns(uint256[] memory){
        uint256[] memory resAmt =  IUniswapV2Router02(Router).swapExactETHForTokens(
            amt, arr, address(this), block.timestamp + 30 minutes
        );
        return resAmt;
    }    
    function ethToUSDC(address[] memory arr, uint256 amt) internal returns(uint256[] memory){
         uint256[] memory resAmt =  IUniswapV2Router02(Router).swapExactETHForTokens(
            amt, arr, address(this), block.timestamp + 30 minutes
        );
        return resAmt;
    }
    function getMyReward(address user) external{

    }
}
