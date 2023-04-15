// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Domainoor.sol";
import "../src/iDomainoor.sol";

contract DomainoorTest is Test {
    Domainoor public domainoor;

    bytes32 public constant DOMAIN_TEST = keccak256("uniswap.org");

    function setUp() public {
        domainoor = new Domainoor();
        domainoor.setDomainOwner(DOMAIN_TEST, address(this));
        address[] memory addresses;
        domainoor.setTrustedContracts(DOMAIN_TEST, addresses);
        domainoor.setState(DOMAIN_TEST, 0);
    }

    function test_configure() public {
        setUp();
        address owner = domainoor.domainOwner(DOMAIN_TEST);
        assertEq(owner, address(this));
    }

    function test_update_domain() public {
        (address[] memory contracts, uint256 state) = domainoor.getDomain(DOMAIN_TEST);
        assertEq(contracts.length, 0); // nothing verified yet
        assertEq(state, 0); // default state

        // now try adding a trusted contract
        address[] memory addresses = new address[](1);
        addresses[0] = address(this);
        domainoor.setTrustedContracts(DOMAIN_TEST, addresses);
        
        (contracts, state) = domainoor.getDomain(DOMAIN_TEST);
        assertEq(contracts.length, 1);
        assertEq(state, 0);
    }
}
