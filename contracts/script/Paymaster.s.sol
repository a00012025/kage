// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/TokenPaymaster.sol";
import "../src/utils/OracleHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployPaymasterScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("DEPLOYER_PRIVATE_KEY"));
        address deployerAddress = vm.envAddress("DEPLOYER_ADDRESS");

        require(
            deployerAddress.balance >= 1e15 + 1e14, // 0.0011 ETH
            "Deployer balance not enough"
        );

        // ETH/USD on arbitrum
        address tokenOracleAddress = address(
            0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612
        );
        address nativeOracleAddress = address(0x0);
        // Entrypoint v0.7.0
        IEntryPoint entryPoint = IEntryPoint(
            0x0000000071727De22E5E9d8BAf0edAc6f37da032
        );
        // USDC on arbitrum
        IERC20Metadata token = IERC20Metadata(
            address(0xaf88d065e77c8cC2239327C5EDb3A432268e5831)
        );
        // WETH on arbitrum
        IERC20Metadata weth = IERC20Metadata(
            address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1)
        );
        // Uniswap V3 Router
        ISwapRouter uniswapV3Router = ISwapRouter(
            0xE592427A0AEce92De3Edee1F18E0157C05861564
        );

        TokenPaymaster.TokenPaymasterConfig memory tokenPaymasterConfig = TokenPaymaster
            .TokenPaymasterConfig({
                priceMarkup: 1e26 + 1e24, // 101%
                minEntryPointBalance: 1e15, // 0.001 ETH
                refundPostopCost: 50000, // gas to transfer token
                priceMaxAge: 2000000
            });
        OracleHelper.OracleHelperConfig memory oracleHelperConfig = OracleHelper
            .OracleHelperConfig({
                cacheTimeToLive: 86400,
                maxOracleRoundAge: 2000000,
                tokenOracle: IOracle(tokenOracleAddress),
                nativeOracle: IOracle(nativeOracleAddress),
                tokenToNativeOracle: true,
                tokenOracleReverse: false,
                nativeOracleReverse: false,
                priceUpdateThreshold: 1e23 // 0.1%
            });
        UniswapHelper.UniswapHelperConfig memory uniswapConfig = UniswapHelper
            .UniswapHelperConfig(0, 3000, 10); // 1% slippage
        TokenPaymaster paymaster = new TokenPaymaster(
            token,
            entryPoint,
            weth,
            uniswapV3Router,
            tokenPaymasterConfig,
            oracleHelperConfig,
            uniswapConfig,
            deployerAddress
        );
        console.log("Deployed TokenPaymaster at:", address(paymaster));
        paymaster.updateCachedPrice(false);
        paymaster.deposit{value: 1e15}(); // deposit 0.001 ETH
        vm.stopBroadcast();
    }
}
