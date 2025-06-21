// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {DAO_RENT} from "../src/DAO_RENT.sol";
import {console} from "forge-std/console.sol";

contract DeployDAO_RENT is Script {

    uint256 public deployerPrivateKey;

    function run() public {
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address usdt = address(0x93C59ae42d899e42f330c57D765AAeC525B82dB2);
        DAO_RENT daoRent = new DAO_RENT(usdt);
        vm.stopBroadcast();
        console.log("DAO_RENT deployed to:", address(daoRent));
    }

    //0xc0b0d48894b8fbff27d6e423ddc4ebb7166f834a
}