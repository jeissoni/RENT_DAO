// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MockUSDT} from "../test/MockUSDT.sol";

contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy MockUSDT first (for testing)
        MockUSDT mockUSDT = new MockUSDT();
        vm.stopBroadcast();
        console.log("MockUSDT deployed to:", address(mockUSDT));
    }
} 