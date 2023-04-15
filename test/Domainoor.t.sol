// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Domainoor.sol";

contract DomainoorTest is Test {
    Domainoor public domainoor;

    bytes32 public constant DOMAIN_TEST = keccak256("uniswap.org");

    function setUp() public {
        domainoor = new Domainoor();
        domainoor.setDomainOwner(DOMAIN_TEST, address(this));
    }

    function test_configure() public {
        setUp();
        address owner = domainoor.domainOwner(DOMAIN_TEST);
        assertEq(owner, address(this));
    }
}
