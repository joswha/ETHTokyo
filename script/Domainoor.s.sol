// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Domainoor} from "../src/Domainoor.sol";

contract DomainoorScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        //Domainoor domainoor = new Domainoor();
        
        vm.stopBroadcast();
    }
}
