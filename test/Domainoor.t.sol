// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Domainoor.sol";

contract DomainoorTest is Test {
    Domainoor public domainoor;

    bytes32 public constant DOMAIN_TEST = keccak256("uniswap.org");

    function setUp() public {
        domainoor = new Domainoor(msg.sender);
        domainoor.setDomainOwner(DOMAIN_TEST, msg.sender);
    }

    function test_configure() public {
        
        assertEq(counter.number(), 1);
    }
}
